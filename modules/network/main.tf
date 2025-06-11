resource "azurerm_virtual_network" "this" {
  name                = "${var.env}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "this" {
  count                                          = length(var.subnets)
  name                                           = "${var.env}-subnet-${count.index + 1}"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = [var.subnets[count.index]]
  private_endpoint_network_policies              = "Disabled"
}
