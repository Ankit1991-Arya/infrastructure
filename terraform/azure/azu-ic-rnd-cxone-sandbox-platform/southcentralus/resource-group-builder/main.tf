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

resource "azurerm_role_assignment" "Default_Reader" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "8bf5c300-927a-4ec4-bb88-f75d906af964"
}

resource "azurerm_role_assignment" "Default_Cost_FinancialAnalysts" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reservation Purchaser"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Reader_NICEDevOps" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "ec97cc03-f16c-4d72-9e0d-65959c486e8f"
}

resource "azurerm_role_assignment" "Default_Reader_CloudNativeCore" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "e69f471f-c6e9-4b5f-9370-cc316e58df1c"
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
