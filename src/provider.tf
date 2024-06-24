provider "azurerm" {
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET

  skip_provider_registration = true
  storage_use_azuread        = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
