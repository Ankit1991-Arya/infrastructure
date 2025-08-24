

data "azurerm_key_vault_certificate" "nicecxone" {
  key_vault_id = var.system_vault_id
  name         = var.ssl_cert_key_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "base" {
  resource_group_name = var.resource_group
  location            = var.location
  name                = format("id-%s-%s", var.ssl_cert_key_name, var.name)
}

resource "azurerm_role_assignment" "policy_access_agw" {
  scope                = var.system_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.base.principal_id
}