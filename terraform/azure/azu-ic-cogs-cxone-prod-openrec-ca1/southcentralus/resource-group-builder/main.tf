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

#DevOps-WEM
resource "azurerm_role_assignment" "Default_DevOps_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "483565da-f079-456f-9461-ac8eb2d10371"
}

#DevOps-WEM
resource "azurerm_role_assignment" "Default_Keyvaultofficer_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "483565da-f079-456f-9461-ac8eb2d10371"
}

#DevOps-WEM
resource "azurerm_role_assignment" "Default_KeyvaultSecretsofficer_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "483565da-f079-456f-9461-ac8eb2d10371"
}

#DevOps-WEM
resource "azurerm_role_assignment" "Default_KeyvaultContributor_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Contributor"
  principal_id         = "483565da-f079-456f-9461-ac8eb2d10371"
}

resource "azurerm_role_assignment" "Default_SPDevOps_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}

resource "azurerm_role_assignment" "Default_SPRDevOps_WEM" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}

#Developers Recording
resource "azurerm_role_assignment" "Default_Developers_Recording" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "00711129-4fbc-4081-b9e7-04feaa58863d"
}

#Developers Recording
resource "azurerm_role_assignment" "Default_keyvault_Recording" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Reader"
  principal_id         = "00711129-4fbc-4081-b9e7-04feaa58863d"
}

#Developers Recording
resource "azurerm_role_assignment" "Default_AppConfig_Recording" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "App Configuration Reader"
  principal_id         = "00711129-4fbc-4081-b9e7-04feaa58863d"
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

resource "azurerm_role_assignment" "Default_SPRDevOps_WEM_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Resource Policy Contributor"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}

resource "azurerm_role_assignment" "Default_SPRDevOps_WEM_SecretsOfficer" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}

resource "azurerm_role_assignment" "Default_SPRDevOps_WEM_DataOwner" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "App Configuration Data Owner"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}

resource "azurerm_role_assignment" "Default_Reader_SystemsOperations" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "809202dc-0825-4b2c-8dbd-ff759881f8b6"
}

resource "azurerm_role_assignment" "Default_Keyvault_SystemsOperations" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "809202dc-0825-4b2c-8dbd-ff759881f8b6"
}

resource "azurerm_role_definition" "Roleassigmnets_jenkins_wem" {
  name        = "Roleassigmnet_jenkins_wem_ca1"
  scope       = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  description = "This is a custom role for jenkins_wem service principal"
  permissions {
    actions = [
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.AppConfiguration/configurationStores/*/write",
      "Microsoft.AppConfiguration/configurationStores/*/read",
      "Microsoft.AppConfiguration/configurationStores/*/delete",
      "Microsoft.Authorization/policyAssignments/write",
      "Microsoft.Authorization/policyDefinitions/write",
      "Microsoft.KeyVault/vaults/secrets/write",
    "Microsoft.KeyVault/vaults/secrets/read"]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "Custom_Roleassigmnet_jenkinswem" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Roleassigmnet_jenkins_wem_ca1"
  principal_id         = "da2bb6c6-4bc7-4592-804f-30d28618e083"
}