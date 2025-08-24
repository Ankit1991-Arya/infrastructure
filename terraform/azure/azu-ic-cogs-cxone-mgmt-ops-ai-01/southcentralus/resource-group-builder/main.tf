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

#CloudArchDirector
resource "azurerm_role_assignment" "Default_CloudArchDirectors_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "b13081ff-b054-495f-8778-8cf6e22ac39b"
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

#DBAs
resource "azurerm_role_assignment" "Default_DBAs_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "778790df-bbb2-4388-afef-7197b4c5e0ac"
}

#DevOpsCNC
resource "azurerm_role_assignment" "Default_DevOpsCNC_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "02991a33-1866-4bf4-8bce-bc763ca68623"
}

#NetworkOperations
resource "azurerm_role_assignment" "Default_NetworkOperations_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "4266f87c-87e9-4051-89b3-0933424d4330"
}

#NetworkEngineering
resource "azurerm_role_assignment" "Default_NetworkEngineering_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "ae1c58b7-38dd-4c30-883e-1fa2d7923bb5"
}

#SystemsEngineering
resource "azurerm_role_assignment" "Default_SystemsEngineering_Contributor" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "c5fbae91-ef32-4918-a74c-03e4fcbaf133"
}