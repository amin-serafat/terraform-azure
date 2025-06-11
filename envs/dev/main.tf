terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dev"
  location = "westeurope"
}

module "network" {
  source              = "../../modules/network"
  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  subnets             = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "security" {
  source              = "../../modules/security"
  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ssh_allowed_cidrs   = ["0.0.0.0/0"]
}

module "compute" {
  source              = "../../modules/compute"
  env                 = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  subnet_id           = module.network.subnet_ids[0]
  nsg_id              = module.security.nsg_id
}

module "storage" {
  source               = "../../modules/storage"
  env                  = "dev"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "amin"
}


resource "azurerm_container_registry" "acr" {
  name                     = "amintest"               
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true
}  

resource "azurerm_service_plan" "asp" {
  name                = "dev-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "amin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/myapp:latest"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }
}  

resource "azurerm_container_group" "aci" {
  name                = "dev-aci"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "dev-aci"

  container {
    name   = "myapp"
    image  = "${azurerm_container_registry.acr.login_server}/myapp:latest"
    cpu    = "1"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}  
