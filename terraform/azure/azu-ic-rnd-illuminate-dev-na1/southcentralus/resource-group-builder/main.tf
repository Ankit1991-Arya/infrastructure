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
  principal_id         = "52c547a9-43a7-4b32-a9e1-b180595ae233"
}

resource "azurerm_role_assignment" "Default_Contributor_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "316200a0-f7ce-4709-997d-67ef071c5fbe"
}

resource "azurerm_role_assignment" "Default_Keyvault_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Contributor"
  principal_id         = "316200a0-f7ce-4709-997d-67ef071c5fbe"
}

resource "azurerm_role_assignment" "Default_OpenAIContributor_Developers" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = "52c547a9-43a7-4b32-a9e1-b180595ae233"
}

resource "azurerm_role_assignment" "Default_Keyvault_Secrets_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "316200a0-f7ce-4709-997d-67ef071c5fbe"
}

resource "azurerm_role_assignment" "Default_Keyvault_Officer_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "316200a0-f7ce-4709-997d-67ef071c5fbe"
}

resource "azurerm_role_assignment" "Default_Keyvault_Crypto_DevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = "316200a0-f7ce-4709-997d-67ef071c5fbe"
}

resource "azurerm_role_assignment" "Default_Contributor_Researchers" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "69270dfe-1998-4483-878b-ff696fce04e7"
}

resource "azurerm_role_assignment" "Default_OpenAIContributor_Researchers" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = "69270dfe-1998-4483-878b-ff696fce04e7"
}

resource "azurerm_role_assignment" "Default_Reader_Architects" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "62211e2b-0e6b-45f4-89ae-5055d2e684a1"
}

resource "azurerm_role_assignment" "Default_OpenAIContributor_Architects" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = "62211e2b-0e6b-45f4-89ae-5055d2e684a1"
}

resource "azurerm_role_assignment" "Default_Reader_SRE" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "c2413c06-0a33-4ec5-9697-514b3aa1e05e"
}

resource "azurerm_role_assignment" "Default_AI_Developer" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Azure AI Developer"
  principal_id         = "52c547a9-43a7-4b32-a9e1-b180595ae233"
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
