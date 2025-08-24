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

resource "azurerm_role_assignment" "Default_Contributor_SysOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "809202dc-0825-4b2c-8dbd-ff759881f8b6"
}

resource "azurerm_role_assignment" "Default_CertificateOfficer_SysOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "809202dc-0825-4b2c-8dbd-ff759881f8b6"
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

resource "azurerm_role_assignment" "Default_Contributor_SRE" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "c2413c06-0a33-4ec5-9697-514b3aa1e05e"
}

resource "azurerm_role_assignment" "Default_Reader_SystemsEngineering" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "c5fbae91-ef32-4918-a74c-03e4fcbaf133"
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

resource "azurerm_role_assignment" "Default_Contributor_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
}

resource "azurerm_role_assignment" "Default_Reader_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
}

