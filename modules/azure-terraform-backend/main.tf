resource "azurerm_resource_group" "tfstate" {
  name     = "ictfstate"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "ictfstate"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_kind                    = lookup(var.tfstate_storage_account_settings, "account_kind", "StorageV2")
  account_tier                    = lookup(var.tfstate_storage_account_settings, "account_tier", "Standard")
  account_replication_type        = lookup(var.tfstate_storage_account_settings, "account_replication_type", "LRS")
  allow_nested_items_to_be_public = false
  tags                            = merge(local.common_tags, var.tfstate_storage_account_tags)

  blob_properties {
    delete_retention_policy {
      days = lookup(var.tfstate_storage_account_settings, "blob_delete_retention_policy", 14)
    }
  }
}
resource "azurerm_storage_container" "tfstate" {
  name                 = "ic-tfstate"
  storage_account_name = azurerm_storage_account.tfstate.name
}