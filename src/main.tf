resource "azurerm_resource_group" "rg_aks" {
  name     = "rg-cac-912772-s1-aks-automatic-01"
  location = "Canada Central"
}
resource "azurerm_resource_group" "rg_managed" {
  name       = "MC_rg-cac-912772-s1-aks-automatic-01_aks-cac-912772-s1-automatic_canadacentral"
  location   = "Canada Central"
  managed_by = "/subscriptions/a73ced30-c712-4405-8828-67a833b1e39a/resourcegroups/rg-cac-912772-s1-aks-automatic-01/providers/Microsoft.ContainerService/managedClusters/aks-cac-912772-s1-automatic"

  tags = {
    "aks-managed-cluster-name" = "aks-cac-912772-s1-automatic"
    "aks-managed-cluster-rg"   = "rg-cac-912772-s1-aks-automatic-01"
  }
}
resource "azurerm_resource_group" "rg_ma" {
  name       = "MA_prom-cac-912772-s1-aks-automatic_canadacentral_managed"
  location   = "Canada Central"
  managed_by = "/subscriptions/a73ced30-c712-4405-8828-67a833b1e39a/resourcegroups/rg-cac-912772-s1-aks-automatic-01/providers/microsoft.monitor/accounts/prom-cac-912772-s1-aks-automatic"
}


