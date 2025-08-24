terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.79"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45"
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

module "resource-group-builder" {
  source       = "../../../../../modules/azure-resource-group-builder"
  location     = "SouthCentralUS"
  ic-region-id = "dt"
  resource_groups_system_map = {
    "arcsqlmonitor" = {
      tags = {
        ApplicationOwner    = "DBAs"
        InfrastructureOwner = "Systems Teams"
      }
    }
  }
}

resource "azurerm_role_assignment" "Default_Owners_CloudOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = "8bf5c300-927a-4ec4-bb88-f75d906af964"
}

resource "azurerm_role_assignment" "Default_Contributor_Administrator_CloudOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = "8bf5c300-927a-4ec4-bb88-f75d906af964"
}

resource "azurerm_role_assignment" "Default_Cost_FinancialAnalyst" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reservation Purchaser"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Contributor_Dept_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
}

resource "azurerm_role_assignment" "Default_Keyvault_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Reader"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
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

resource "azurerm_role_assignment" "Default_Reader_DBAs" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "778790df-bbb2-4388-afef-7197b4c5e0ac"
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

resource "azurerm_role_assignment" "Default_Contributor_CloudNativeCore" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "e69f471f-c6e9-4b5f-9370-cc316e58df1c"
}

resource "azurerm_role_assignment" "Default_VaultSecrets_CloudNativeCore" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = "e69f471f-c6e9-4b5f-9370-cc316e58df1c"
}

resource "azurerm_role_assignment" "Default_VaultReader_CloudNativeCore" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Reader"
  principal_id         = "e69f471f-c6e9-4b5f-9370-cc316e58df1c"
}

resource "azurerm_role_assignment" "Default_ResourceContributor_DBAs" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}/resourceGroups/arcsqlmonitor-dev"
  role_definition_name = "Contributor"
  principal_id         = "778790df-bbb2-4388-afef-7197b4c5e0ac"
}
