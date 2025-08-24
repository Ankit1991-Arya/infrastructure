data "azurerm_key_vault" "EnvVar" {
  name                = "ic-envvar-${var.ic-region-id}"
  resource_group_name = "regionconfig-${var.ic-region-id}"
}

data "azurerm_key_vault_secret" "EnvVar" {
  for_each     = local.EnvVar_secrets_list
  name         = each.value
  key_vault_id = data.azurerm_key_vault.EnvVar.id
}

resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups_map

  name     = "${each.key}-${var.ic-region-id}"
  location = var.location
  tags     = merge(local.common_tags, each.value.tags)
}

resource "azurerm_resource_group" "resource_groups_system_id" {
  for_each = var.resource_groups_system_map
  name     = "${each.key}-${data.azurerm_key_vault_secret.EnvVar["cxone-system-id"].value}"
  location = var.location
  tags     = merge(local.common_tags, each.value.tags)
}

resource "azurerm_resource_group" "resource_groups_area_id" {
  for_each = var.resource_groups_area_map
  name     = "${each.key}-${data.azurerm_key_vault_secret.EnvVar["cxone-area-id"].value}"
  location = var.location
  tags     = merge(local.common_tags, each.value.tags)
}

resource "azuread_application" "ad_application" {
  for_each     = var.repository_role_assignment
  display_name = each.key
}

resource "azuread_service_principal" "service_principal" {
  for_each                     = var.repository_role_assignment
  application_id               = azuread_application.ad_application[each.key].application_id
  app_role_assignment_required = false
}

resource "azurerm_role_assignment" "role_assignment" {
  count                = length(local.role_assignments)
  scope                = azurerm_resource_group.resource_groups[local.role_assignments[count.index]["group_name"]].id
  role_definition_name = local.role_assignments[count.index]["role_name"]
  principal_id         = azuread_service_principal.service_principal[local.role_assignments[count.index]["repository_name"]].id
}