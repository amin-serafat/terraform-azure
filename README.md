# Terraform Azure Infrastructure – Dev Environment

   ![jpg (2)](https://github.com/user-attachments/assets/5cc28973-e54e-43a9-adfb-098f5080f838)



This project provisions a complete Azure environment for development, including:

- Resource Group  
- Virtual Network & Subnets (via a local module)  
- Network Security Group  
- Linux VM  
- Storage Account  
- Azure Container Registry  
- App Service Plan & Linux Web App (container-based)  
- Azure Container Instance  
- public SSH key at ~/.ssh/id_rsa.pub for the VM module.
- Docker image called myapp:latest pushed to ACR after apply

---


```
terraform-azure/
└── envs/
    └── dev/
        ├── main.tf            
        └── backend.tf        
└── modules/
    ├── network/              # VNet/subnet module
    ├── security/             # NSG module
    ├── compute/              # VM module
    └── storage/              # Storage Account module

```

## Configuration
Review & customize resource names in envs/dev/main.tf:

- Resource Group rg-dev
- Storage Account name (amin)
- ACR name (amintest)
- Web App name (amin)
- ACI DNS label (dev-aci)
- VM SSH CIDR (0.0.0.0/0)


## Deployment Steps

### Initialize Terraform
- cd envs/dev
     - terraform init

### Validate & Format

- terraform fmt 
- terraform validate

### Generate & Review Plan

- terraform plan -out=plan.tfplan

### Apply

- terraform apply plan.tfplan


## Implementation 
I want to clarify about implementation process, I used the two type of terraform code : 
- creating resource from internal module
- craeting resource direcrly

Exampel : for creating container-registry : 
```
resource "azurerm_container_registry" "acr" {
  name                     = "amintest"               
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true
}  
```
or call external module 
```
module "container-registry" {
  source  = "kumarvna/container-registry/azurerm"
  version = "1.0.0"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  container_registry_config = {
    name          = "containerregistrydemoproject01"
    admin_enabled = true
    sku           = "Premium"
  }

  georeplications = [
    { location = "northeurope";     zone_redundancy_enabled = true },
    { location = "francecentral";   zone_redundancy_enabled = true },
    { location = "uksouth";         zone_redundancy_enabled = true },
  ]

  retention_policy = {
    days    = 10
    enabled = true
  }

  enable_content_trust = true

  enable_private_endpoint       = false
  virtual_network_name          = "vnet-shared-hub-westeurope-001"
  private_subnet_address_prefix = ["10.1.5.0/27"]

  log_analytics_workspace_name = "loganalytics-we-sharedtest2"

  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }

  depends_on = [azurerm_resource_group.rg]
}
```


