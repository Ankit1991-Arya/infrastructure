data "azurerm_resource_group" "regionconfig" {
  name = "regionconfig-${var.ic-region-id}"
}

# tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "EnvVar" {
  name                       = "ic-envvar-${var.ic-region-id}"
  resource_group_name        = data.azurerm_resource_group.regionconfig.name
  location                   = data.azurerm_resource_group.regionconfig.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 14
  purge_protection_enabled   = true
  tags                       = merge(local.common_tags, {})
}

# resource "azurerm_monitor_diagnostic_setting" "EnvVar" {
#   name                           = "diags"
#   target_resource_id             = azurerm_key_vault.EnvVar.id
#   eventhub_name                  = "insights-activity-logs"
#   eventhub_authorization_rule_id = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"

#   log {
#     category = "AuditEvent"

#     retention_policy {
#       enabled = false
#       days    = 0 # retain events indefinitely
#     }
#   }
# }

resource "azapi_resource" "EnvVar_keyvault_diagnostics" {
  type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
  name      = "auditevents_to_eventhub"
  parent_id = azurerm_key_vault.EnvVar.id

  body = jsonencode({
    properties = {
      eventHubAuthorizationRuleId = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"
      eventHubName                = "insights-activity-logs"
      logs = [
        {
          category = "AuditEvent"
          enabled  = true
          retentionPolicy = {
            days    = 0
            enabled = false
          }
        }
      ]
    }
  })
}

resource "azurerm_key_vault_secret" "EnvVar" {
  for_each = local.environment_variables

  key_vault_id = azurerm_key_vault.EnvVar.id
  name         = each.key
  value        = each.value
  tags         = merge(local.common_tags, {})
}

# tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "Systems" {
  name                       = "ic-systems-${var.ic-region-id}"
  resource_group_name        = data.azurerm_resource_group.regionconfig.name
  location                   = data.azurerm_resource_group.regionconfig.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 14
  purge_protection_enabled   = true
  tags                       = merge(local.common_tags, {})
}

# resource "azurerm_monitor_diagnostic_setting" "Systems" {
#   name                           = "diags"
#   target_resource_id             = azurerm_key_vault.Systems.id
#   eventhub_name                  = "insights-activity-logs"
#   eventhub_authorization_rule_id = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"

#   log {
#     category = "AuditEvent"

#     retention_policy {
#       enabled = false
#       days    = 0 # retain events indefinitely
#     }
#   }
# }

resource "azapi_resource" "Systems_keyvault_diagnostics" {
  type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
  name      = "auditevents_to_eventhub"
  parent_id = azurerm_key_vault.Systems.id

  body = jsonencode({
    properties = {
      eventHubAuthorizationRuleId = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"
      eventHubName                = "insights-activity-logs"
      logs = [
        {
          category = "AuditEvent"
          enabled  = true
          retentionPolicy = {
            days    = 0
            enabled = false
          }
        }
      ]
    }
  })
}

resource "azurerm_key_vault_secret" "AdJoinerUsername" {
  name         = "ad-domain-joiner-username"
  value        = var.ad-domain-joiner-username
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "AdJoinerPassword" {
  name         = "ad-domain-joiner-password"
  value        = "DummyPassword"
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tls_private_key" "SystemsKeyPair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "SystemsKeyPairPrivateKey" {
  name         = "SystemsKeyPairPrivateKey${var.ic-region-id}"
  value        = tls_private_key.SystemsKeyPair.private_key_pem
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "SystemsKeyPairPublicKeyPEM" {
  name         = "SystemsKeyPairPublicKeyPEM"
  value        = trimspace("${tls_private_key.SystemsKeyPair.public_key_pem}")
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "SystemsKeyPairPublicKeyOpenSSH" {
  name         = "SystemsKeyPairPublicKeyOpenSSH"
  value        = trimspace("${tls_private_key.SystemsKeyPair.public_key_openssh}")
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "chef-validation-key" {
  name         = "chef-validation-key"
  value        = "DummyValue"
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "chef-server-crt" {
  name         = "chef-server-crt"
  value        = "DummyValue"
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "ssl-cert-name-nicecxone" {
  name         = "ssl-cert-name-nicecxone"
  value        = "DummyValue"
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "ssl-cert-thumbprint-nicecxone" {
  name         = "ssl-cert-thumbprint-nicecxone"
  value        = "DummyValue"
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})

  lifecycle {
    ignore_changes = [value]
  }
}

# Network Infrastructure
data "azurerm_resource_group" "networkinfra" {
  name = "networkinfra-${var.ic-region-id}"
}

# tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "Network" {
  name                       = "ic-network-${var.ic-region-id}"
  resource_group_name        = data.azurerm_resource_group.networkinfra.name
  location                   = data.azurerm_resource_group.networkinfra.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 14
  purge_protection_enabled   = true
  tags = merge(
    local.common_tags,
    {
      "ApplicationOwner"    = "Network Teams"
      "InfrastructureOwner" = "Network Teams"
    }
  )
}

# resource "azurerm_monitor_diagnostic_setting" "Network" {
#   name                           = "diags"
#   target_resource_id             = azurerm_key_vault.Network.id
#   eventhub_name                  = "insights-activity-logs"
#   eventhub_authorization_rule_id = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"

#   log {
#     category = "AuditEvent"

#     retention_policy {
#       enabled = false
#       days    = 0 # retain events indefinitely
#     }
#   }
# }

resource "azapi_resource" "Network_keyvault_diagnostics" {
  type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
  name      = "auditevents_to_eventhub"
  parent_id = azurerm_key_vault.Network.id

  body = jsonencode({
    properties = {
      eventHubAuthorizationRuleId = "/subscriptions/27f02aa4-974a-42c6-b7d3-cdeb635ba264/resourcegroups/cxone-event-hub/providers/Microsoft.EventHub/namespaces/shared-logging/authorizationrules/RootManageSharedAccessKey"
      eventHubName                = "insights-activity-logs"
      logs = [
        {
          category = "AuditEvent"
          enabled  = true
          retentionPolicy = {
            days    = 0
            enabled = false
          }
        }
      ]
    }
  })
}

resource "tls_private_key" "NetworkKeyPair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "NetworkKeyPairPrivateKey" {
  name         = "NetworkKeyPairPrivateKey${var.ic-region-id}"
  value        = tls_private_key.NetworkKeyPair.private_key_pem
  key_vault_id = azurerm_key_vault.Network.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "NetworkKeyPairPublicKey" {
  name         = "NetworkKeyPairPublicKey${var.ic-region-id}"
  value        = trimspace("${tls_private_key.NetworkKeyPair.public_key_pem}")
  key_vault_id = azurerm_key_vault.Network.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "NetworkKeyPairPublicKeyOpenSSH" {
  name         = "NetworkKeyPairPublicKey${var.ic-region-id}OpenSSH"
  value        = trimspace("${tls_private_key.NetworkKeyPair.public_key_openssh}")
  key_vault_id = azurerm_key_vault.Network.id
  tags         = merge(local.common_tags, {})
}

# Disk Initialization
# tfsec:ignore:azure-storage-use-secure-tls-policy
resource "azurerm_storage_account" "dsc" {
  name                            = "icsystemsdiskinit${var.ic-region-id}"
  resource_group_name             = data.azurerm_resource_group.regionconfig.name
  location                        = data.azurerm_resource_group.regionconfig.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "dsc" {
  name                 = "diskinitdsc"
  storage_account_name = azurerm_storage_account.dsc.name
}

data "azurerm_storage_account_blob_container_sas" "dsc" {
  connection_string = azurerm_storage_account.dsc.primary_blob_connection_string
  container_name    = azurerm_storage_container.dsc.name
  start             = "2022-10-12"
  expiry            = "2023-10-13"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

resource "azurerm_key_vault_secret" "dsc-disk-init-sas" {
  name         = "dsc-disk-init-sas"
  value        = data.azurerm_storage_account_blob_container_sas.dsc.sas
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_storage_blob" "dsc" {
  name                   = "DiskInitialization.zip"
  storage_account_name   = azurerm_storage_account.dsc.name
  storage_container_name = azurerm_storage_container.dsc.name
  type                   = "Block"
  source                 = "${path.module}/powershell-dsc/DiskInitialization.zip"
}

resource "azurerm_key_vault_secret" "dsc-disk-init-url" {
  name         = "dsc-disk-init-url"
  value        = azurerm_storage_blob.dsc.url
  key_vault_id = azurerm_key_vault.Systems.id
  tags         = merge(local.common_tags, {})
}

resource "azurerm_key_vault_secret" "cxone-system-id" {
  name         = "cxone-system-id"
  value        = var.cxone-system-id
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})
}
resource "azurerm_key_vault_secret" "cxone-area-id" {
  name         = "cxone-area-id"
  value        = var.cxone-area-id
  key_vault_id = azurerm_key_vault.EnvVar.id
  tags         = merge(local.common_tags, {})
}