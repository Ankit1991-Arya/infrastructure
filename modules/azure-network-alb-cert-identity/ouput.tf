output "principal_id" {
  value = azurerm_user_assigned_identity.base.id
}
output "key_vault_secret_id" {
  value = data.azurerm_key_vault_certificate.nicecxone.secret_id
}
