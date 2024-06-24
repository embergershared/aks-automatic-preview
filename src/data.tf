### Gathering all resources
data "azurerm_resources" "resources_aks" {
  resource_group_name = azurerm_resource_group.rg_aks.name
}
data "azurerm_resources" "resources_managed" {
  resource_group_name = azurerm_resource_group.rg_managed.name
}
data "azurerm_resources" "resources_ma" {
  resource_group_name = azurerm_resource_group.rg_ma.name
}
