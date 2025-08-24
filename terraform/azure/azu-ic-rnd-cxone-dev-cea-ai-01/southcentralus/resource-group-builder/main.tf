terraform {
  required_version = "~>1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.22"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.29.0"
    }
  }
}

provider "azurerm" {
  # Authentication variables will be configured by environment variables
  features {}
}

provider "azuread" {
  # Authentication variables will be configured by environment variables
}

data "azurerm_subscription" "this" {}

resource "azurerm_role_assignment" "Default_Reader_Developers" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "f582ee3c-67d6-4f84-b219-fafa21b286a4"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_Contributor_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "158999c2-3783-467c-b98e-477472355496"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_ContributorAdministrator_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/dev1-ncus-openai/providers/Microsoft.KeyVault/vaults/dev1-ncus-cea-openai"
  role_definition_name = "User Access Administrator"
  principal_id         = "158999c2-3783-467c-b98e-477472355496"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_SPNAdministrator_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/dev1-ncus-openai/providers/Microsoft.KeyVault/vaults/dev1-ncus-cea-openai"
  role_definition_name = "User Access Administrator"
  principal_id         = "1b781f36-73c9-4a84-b2db-4fb7bf337c08"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_UserAccessSPNAdministrator_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/dev2-sdc-openai/providers/Microsoft.KeyVault/vaults/dev2-sdc-cea-openai"
  role_definition_name = "User Access Administrator"
  principal_id         = "1b781f36-73c9-4a84-b2db-4fb7bf337c08"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_KeyvaultSecretsOfficer_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "1b781f36-73c9-4a84-b2db-4fb7bf337c08"
}

#CEADevOps
resource "azurerm_role_assignment" "Default_KeyvaultContributor_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Contributor"
  principal_id         = "1b781f36-73c9-4a84-b2db-4fb7bf337c08"
}

resource "azurerm_role_assignment" "Default_Cost_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reservation Purchaser"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Contributor_Admin_CloudOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = "8bf5c300-927a-4ec4-bb88-f75d906af964"
}

resource "azurerm_role_assignment" "Default_Billing_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Billing Reader"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_CostManagement_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Cost Management Reader"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Savingsplan_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Savings plan Purchaser"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Reader_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}
