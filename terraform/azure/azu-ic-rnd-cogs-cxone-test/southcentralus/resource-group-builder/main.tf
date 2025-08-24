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

module "resource-group-builder" {
  source = "../../../../../modules/azure-resource-group-builder"

  ic-region-id = "tt"
  location     = "SouthCentralUS"
}

data "azurerm_subscription" "this" {}

resource "azurerm_role_definition" "Virtual_Machine_Start_Stop" {
  name        = "Virtual_Machine_Start_Stop"
  scope       = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  description = "This is a custom role for start/Stop VM"
  permissions {
    actions = [
      "Microsoft.Network/*/read",
      "Microsoft.Compute/*/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
    "Microsoft.Compute/virtualMachines/deallocate/action"]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "Reader_role" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Reader"
  for_each             = var.group_adname
  principal_id         = each.value
}
resource "azurerm_role_definition" "Default_reader_role" {
  name        = "Default_reader_role"
  scope       = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  description = "This is a custom reader role created via Terraform"
  permissions {
    actions     = ["Microsoft.Management/managementGroups/subscriptions/read"]
    not_actions = []
  }
}

resource "azurerm_role_definition" "Release_Engineering_Test" {
  name        = "Release_Engineering_Test"
  scope       = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  description = "This is a custom role for Release Engineering Team"
  permissions {
    actions = [
      "Microsoft.Support/register/action",
      "Microsoft.Support/lookUpResourceId/action",
      "Microsoft.Support/operationresults/read",
      "Microsoft.Support/operationsstatus/read",
      "Microsoft.Support/operations/read",
      "Microsoft.Support/services/read",
      "Microsoft.Support/services/problemClassifications/read",
      "Microsoft.Support/supportTickets/read",
      "Microsoft.Support/supportTickets/write",
      "Microsoft.ApiManagement/service/gateways/apis/read",
      "Microsoft.ApiManagement/service/gateways/apis/write",
      "Microsoft.ApiManagement/service/gateways/apis/delete",
      "Microsoft.ApiManagement/service/tags/apiLinks/read",
      "Microsoft.Network/dnszones/CNAME/read",
      "Microsoft.Network/dnszones/MX/read",
      "Microsoft.Network/dnszones/PTR/read",
      "Microsoft.Network/dnszones/SRV/read",
      "Microsoft.Network/dnszones/TXT/read",
      "Microsoft.Network/dnszones/all/read",
      "Microsoft.Network/dnszones/NS/read",
      "Microsoft.Network/dnszones/SOA/read",
      "Microsoft.ContainerService/register/action",
      "Microsoft.ContainerService/unregister/action",
      "Microsoft.ContainerService/operations/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.ContainerService/containerServices/write",
      "Microsoft.ContainerService/containerServices/delete",
      "Microsoft.ContainerService/fleets/read",
      "Microsoft.ContainerService/fleets/write",
      "Microsoft.ContainerService/fleets/delete",
      "Microsoft.ContainerService/fleets/listCredentials/action",
      "Microsoft.ContainerService/fleets/members/read",
      "Microsoft.ContainerService/fleets/members/write",
      "Microsoft.ContainerService/fleets/members/delete",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/write",
      "Microsoft.ContainerService/managedClusters/delete",
      "Microsoft.ContainerService/managedClusters/start/action",
      "Microsoft.ContainerService/managedClusters/stop/action",
      "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
      "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
      "Microsoft.ContainerService/managedClusters/listClusterMonitoringUserCredential/action",
      "Microsoft.ContainerService/managedClusters/resetServicePrincipalProfile/action",
      "Microsoft.ContainerService/managedClusters/unpinManagedCluster/action",
      "Microsoft.ContainerService/managedClusters/resolvePrivateLinkServiceId/action",
      "Microsoft.ContainerService/managedClusters/resetAADProfile/action",
      "Microsoft.ContainerService/managedClusters/rotateClusterCertificates/action",
      "Microsoft.ContainerService/managedClusters/runCommand/action",
      "Microsoft.ContainerService/managedClusters/privateEndpointConnectionsApproval/action",
      "Microsoft.ContainerService/managedClusters/agentPools/read",
      "Microsoft.ContainerService/managedClusters/agentPools/write",
      "Microsoft.ContainerService/managedClusters/agentPools/delete",
      "Microsoft.ContainerService/managedClusters/agentPools/upgradeNodeImageVersion/write",
      "Microsoft.ContainerService/managedClusters/agentPools/upgradeProfiles/read",
      "Microsoft.ContainerService/managedClusters/diagnosticsState/read",
      "Microsoft.ContainerService/managedClusters/eventGridFilters/read",
      "Microsoft.ContainerService/managedClusters/eventGridFilters/write",
      "Microsoft.ContainerService/managedClusters/eventGridFilters/delete",
      "Microsoft.ContainerService/managedClusters/extensionaddons/read",
      "Microsoft.ContainerService/managedClusters/extensionaddons/write",
      "Microsoft.ContainerService/managedClusters/extensionaddons/delete",
      "Microsoft.ContainerService/managedClusters/maintenanceConfigurations/read",
      "Microsoft.ContainerService/managedClusters/maintenanceConfigurations/write",
      "Microsoft.ContainerService/managedClusters/maintenanceConfigurations/delete",
      "Microsoft.ContainerService/managedClusters/detectors/read",
      "Microsoft.ContainerService/managedClusters/accessProfiles/read",
      "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action",
      "Microsoft.ContainerService/managedClusters/availableAgentPoolVersions/read",
      "Microsoft.ContainerService/managedClusters/commandResults/read",
      "Microsoft.ContainerService/managedClusters/guardrailsVersions/read",
      "Microsoft.ContainerService/managedClusters/networkSecurityPerimeterAssociationProxies/read",
      "Microsoft.ContainerService/managedClusters/networkSecurityPerimeterAssociationProxies/write",
      "Microsoft.ContainerService/managedClusters/networkSecurityPerimeterAssociationProxies/delete",
      "Microsoft.ContainerService/managedClusters/networkSecurityPerimeterConfigurations/read",
      "Microsoft.ContainerService/managedClusters/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.ContainerService/managedClusters/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.ContainerService/managedClusters/trustedAccessRoleBindings/read",
      "Microsoft.ContainerService/managedClusters/trustedAccessRoleBindings/write",
      "Microsoft.ContainerService/managedClusters/trustedAccessRoleBindings/delete",
      "Microsoft.ContainerService/managedClusters/privateEndpointConnections/read",
      "Microsoft.ContainerService/managedClusters/privateEndpointConnections/write",
      "Microsoft.ContainerService/managedClusters/privateEndpointConnections/delete",
      "Microsoft.ContainerService/managedClusters/providers/Microsoft.Insights/logDefinitions/read",
      "Microsoft.ContainerService/managedClusters/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.ContainerService/managedClusters/upgradeProfiles/read",
      "Microsoft.ContainerService/managedclustersnapshots/read",
      "Microsoft.ContainerService/managedclustersnapshots/write",
      "Microsoft.ContainerService/managedclustersnapshots/delete",
      "Microsoft.ContainerService/fleetMemberships/read",
      "Microsoft.ContainerService/fleetMemberships/write",
      "Microsoft.ContainerService/fleetMemberships/delete",
      "Microsoft.ContainerService/locations/osOptions/read",
      "Microsoft.ContainerService/openShiftClusters/read",
      "Microsoft.ContainerService/openShiftClusters/write",
      "Microsoft.ContainerService/openShiftClusters/delete",
      "Microsoft.ContainerService/openShiftManagedClusters/read",
      "Microsoft.ContainerService/openShiftManagedClusters/write",
      "Microsoft.ContainerService/openShiftManagedClusters/delete",
      "Microsoft.ContainerService/locations/operations/read",
      "Microsoft.ContainerService/locations/operationresults/read",
      "Microsoft.ContainerService/locations/orchestrators/read",
      "Microsoft.ContainerService/snapshots/read",
      "Microsoft.ContainerService/snapshots/write",
      "Microsoft.ContainerService/snapshots/delete",
      "Microsoft.Devops/deploymentDetails/Read",
      "Microsoft.Devops/deploymentDetails/Write",
      "Microsoft.Devops/deploymentDetails/Delete",
      "Microsoft.Resources/deployments/write",
      "Microsoft.Resources/deployments/read",
      "Microsoft.Resources/deployments/operations/read",
      "Microsoft.Resources/deployments/operationstatuses/read",
      "Microsoft.Resources/deploymentScripts/read",
      "Microsoft.Resources/deploymentScripts/write",
      "Microsoft.Resources/deploymentScripts/logs/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.Resources/resources/read",
      "Microsoft.Resources/subscriptions/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourcegroups/deployments/read",
      "Microsoft.Resources/subscriptions/resourcegroups/deployments/write",
      "Microsoft.Resources/subscriptions/resourcegroups/resources/read",
      "Microsoft.Resources/subscriptions/providers/read",
      "Microsoft.Resources/templateSpecs/read",
      "Microsoft.Storage/register/action",
      "Microsoft.Storage/deletedAccounts/read",
      "Microsoft.Storage/resilienciesProgressions/read",
      "Microsoft.Storage/storageTasks/read",
      "Microsoft.Storage/storageTasks/delete",
      "Microsoft.Storage/storageTasks/promote/action",
      "Microsoft.Storage/storageTasks/write",
      "Microsoft.Storage/locations/deleteVirtualNetworkOrSubnets/action",
      "Microsoft.Storage/locations/notifyNetworkSecurityPerimeterUpdatesAvailable/action",
      "Microsoft.Storage/locations/checknameavailability/read",
      "Microsoft.Storage/locations/usages/read",
      "Microsoft.Storage/checknameavailability/read",
      "Microsoft.Storage/operations/read",
      "Microsoft.Storage/skus/read",
      "Microsoft.Storage/storageAccounts/updateInternalProperties/action",
      "Microsoft.Storage/storageAccounts/consumerDataShare/action",
      "Microsoft.Storage/storageAccounts/hnsonmigration/action",
      "Microsoft.Storage/storageAccounts/networkSecurityPerimeterConfigurations/action",
      "Microsoft.Storage/storageAccounts/privateEndpointConnections/action",
      "Microsoft.Storage/storageAccounts/restoreBlobRanges/action",
      "Microsoft.Storage/storageAccounts/PrivateEndpointConnectionsApproval/action",
      "Microsoft.Storage/storageAccounts/failover/action",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/rotateKey/action",
      "Microsoft.Storage/storageAccounts/revokeUserDelegationKeys/action",
      "Microsoft.Storage/storageAccounts/joinPerimeter/action",
      "Microsoft.Storage/storageAccounts/delete",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/listAccountSas/action",
      "Microsoft.Storage/storageAccounts/listServiceSas/action",
      "Microsoft.Storage/storageAccounts/write",
      "Microsoft.Storage/storageAccounts/accountLocks/deleteLock/action",
      "Microsoft.Storage/storageAccounts/accountLocks/read",
      "Microsoft.Storage/storageAccounts/accountLocks/write",
      "Microsoft.Storage/storageAccounts/accountLocks/delete",
      "Microsoft.Storage/storageAccounts/accountMigrations/read",
      "Microsoft.Storage/storageAccounts/accountMigrations/write",
      "Microsoft.Storage/storageAccounts/consumerDataSharePolicies/read",
      "Microsoft.Storage/storageAccounts/consumerDataSharePolicies/write",
      "Microsoft.Storage/storageAccounts/dataSharePolicies/delete",
      "Microsoft.Storage/storageAccounts/dataSharePolicies/read",
      "Microsoft.Storage/storageAccounts/dataSharePolicies/write",
      "Microsoft.Storage/storageAccounts/encryptionScopes/read",
      "Microsoft.Storage/storageAccounts/encryptionScopes/write",
      "Microsoft.Storage/storageAccounts/inventoryPolicies/delete",
      "Microsoft.Storage/storageAccounts/inventoryPolicies/read",
      "Microsoft.Storage/storageAccounts/inventoryPolicies/write",
      "Microsoft.Storage/storageAccounts/networkSecurityPerimeterAssociationProxies/delete",
      "Microsoft.Storage/storageAccounts/networkSecurityPerimeterAssociationProxies/read",
      "Microsoft.Storage/storageAccounts/networkSecurityPerimeterAssociationProxies/write",
      "Microsoft.Storage/storageAccounts/networkSecurityPerimeterConfigurations/read",
      "Microsoft.Storage/storageAccounts/storageTasks/delete",
      "Microsoft.Storage/storageAccounts/storageTasks/read",
      "Microsoft.Storage/storageAccounts/storageTasks/executionsummary/action",
      "Microsoft.Storage/storageAccounts/storageTasks/assignmentexecutionsummary/action",
      "Microsoft.Storage/storageAccounts/storageTasks/write",
      "Microsoft.Storage/storageAccounts/localUsers/delete",
      "Microsoft.Storage/storageAccounts/localusers/regeneratePassword/action",
      "Microsoft.Storage/storageAccounts/localusers/listKeys/action",
      "Microsoft.Storage/storageAccounts/localusers/read",
      "Microsoft.Storage/storageAccounts/localusers/write",
      "Microsoft.Storage/storageAccounts/objectReplicationPolicies/delete",
      "Microsoft.Storage/storageAccounts/objectReplicationPolicies/read",
      "Microsoft.Storage/storageAccounts/objectReplicationPolicies/write",
      "Microsoft.Storage/storageAccounts/objectReplicationPolicies/restorePointMarkers/write",
      "Microsoft.Storage/storageAccounts/restorePoints/delete",
      "Microsoft.Storage/storageAccounts/restorePoints/read",
      "Microsoft.Storage/storageAccounts/managementPolicies/delete",
      "Microsoft.Storage/storageAccounts/managementPolicies/read",
      "Microsoft.Storage/storageAccounts/managementPolicies/write",
      "Microsoft.Storage/storageAccounts/privateEndpointConnections/read",
      "Microsoft.Storage/storageAccounts/privateEndpointConnections/delete",
      "Microsoft.Storage/storageAccounts/privateEndpointConnections/write",
      "Microsoft.Storage/storageAccounts/privateEndpointConnectionProxies/read",
      "Microsoft.Storage/storageAccounts/privateEndpointConnectionProxies/updatePrivateEndpointProperties/action",
      "Microsoft.Storage/storageAccounts/privateEndpointConnectionProxies/delete",
      "Microsoft.Storage/storageAccounts/privateEndpointConnectionProxies/write",
      "Microsoft.Storage/storageAccounts/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Storage/storageAccounts/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.Storage/storageAccounts/services/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/blobServices/read",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
      "Microsoft.Storage/storageAccounts/blobServices/write",
      "Microsoft.Storage/storageAccounts/blobServices/providers/Microsoft.Insights/logDefinitions/read",
      "Microsoft.Storage/storageAccounts/blobServices/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Storage/storageAccounts/blobServices/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/blobServices/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/migrate/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/lease/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/clearLegalHold/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/setLegalHold/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies/extend/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies/lock/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies/read",
      "Microsoft.Storage/storageAccounts/fileServices/shares/action",
      "Microsoft.Storage/storageAccounts/fileServices/read",
      "Microsoft.Storage/storageAccounts/fileServices/write",
      "Microsoft.Storage/storageAccounts/fileServices/providers/Microsoft.Insights/logDefinitions/read",
      "Microsoft.Storage/storageAccounts/fileServices/shares/delete",
      "Microsoft.Storage/storageAccounts/fileServices/shares/read",
      "Microsoft.Storage/storageAccounts/fileServices/shares/lease/action",
      "Microsoft.Storage/storageAccounts/fileServices/shares/write",
      "Microsoft.Storage/storageAccounts/fileServices/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Storage/storageAccounts/fileServices/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/fileServices/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.Storage/storageAccounts/queueServices/read",
      "Microsoft.Storage/storageAccounts/queueServices/write",
      "Microsoft.Storage/storageAccounts/queueServices/providers/Microsoft.Insights/logDefinitions/read",
      "Microsoft.Storage/storageAccounts/queueServices/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Storage/storageAccounts/queueServices/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/queueServices/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.Storage/storageAccounts/queueServices/queues/delete",
      "Microsoft.Storage/storageAccounts/queueServices/queues/read",
      "Microsoft.Storage/storageAccounts/queueServices/queues/write",
      "Microsoft.Storage/storageAccounts/tableServices/read",
      "Microsoft.Storage/storageAccounts/tableServices/write",
      "Microsoft.Storage/storageAccounts/tableServices/tables/delete",
      "Microsoft.Storage/storageAccounts/tableServices/tables/read",
      "Microsoft.Storage/storageAccounts/tableServices/tables/write",
      "Microsoft.Storage/storageAccounts/tableServices/providers/Microsoft.Insights/logDefinitions/read",
      "Microsoft.Storage/storageAccounts/tableServices/providers/Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Storage/storageAccounts/tableServices/providers/Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Storage/storageAccounts/tableServices/providers/Microsoft.Insights/metricDefinitions/read",
      "Microsoft.Storage/storageAccounts/privateLinkResources/read",
      "Microsoft.Storage/usages/read",
      "Microsoft.StreamAnalytics/streamingjobs/Read",
      "Microsoft.StreamAnalytics/streamingjobs/Delete",
      "Microsoft.StreamAnalytics/streamingjobs/Write",
      "Microsoft.StreamAnalytics/streamingjobs/operationresults/Read",
    "Microsoft.StreamAnalytics/streamingjobs/metricdefinitions/Read"]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "VM_Start_Stop" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Virtual_Machine_Start_Stop"
  principal_id         = "486c88ce-773c-40b0-bd83-211333c8c4b6"
}

resource "azurerm_role_assignment" "Release_Engineering_Test1" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Virtual_Machine_Start_Stop"
  principal_id         = "4782b9b4-d9dd-4b88-a7f4-1a28e1037d80"
}

resource "azurerm_role_assignment" "Release_Engineering_Test" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Release_Engineering_Test"
  principal_id         = "4782b9b4-d9dd-4b88-a7f4-1a28e1037d80"
}

resource "azurerm_role_assignment" "VM_Start_Stop_Test_SysEngg" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Virtual_Machine_Start_Stop"
  principal_id         = "c5fbae91-ef32-4918-a74c-03e4fcbaf133"
}

resource "azurerm_role_assignment" "Developers_StorageServices" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Owner"
  principal_id         = "c1561a47-0869-4db8-8697-bc2197a9cf2d"
}

resource "azurerm_role_assignment" "Default_CertificatesOfficer_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
}

resource "azurerm_role_assignment" "Default_VaultSecrets_NetworkArchitecture" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = "e19b7d1c-359e-4594-abaa-15c58f3937de"
}

resource "azurerm_role_assignment" "Default_Cost_FinancialAnalysts" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Reservation Purchaser"
  principal_id         = "a51ce4d6-488b-4c03-bb6d-34672a24ee5d"
}

resource "azurerm_role_assignment" "Default_Contributor_NetworkOperations" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Contributor"
  principal_id         = "4266f87c-87e9-4051-89b3-0933424d4330"
}

resource "azurerm_role_assignment" "Default_Reader_NetworkOperations" {
  scope                = "/subscriptions/56a46408-b4a2-45df-aef5-92cddf4ef946"
  role_definition_name = "Reader"
  principal_id         = "4266f87c-87e9-4051-89b3-0933424d4330"
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

resource "azurerm_role_assignment" "Default_Reader_StorageServices" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = "5df995a4-26c9-4322-8407-1462aa3e9b94"
}

resource "azurerm_role_assignment" "Default_Contributor_StorageServices" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "5df995a4-26c9-4322-8407-1462aa3e9b94"
}

resource "azurerm_role_assignment" "Default_Contributor_SystemsEngineering" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = "c5fbae91-ef32-4918-a74c-03e4fcbaf133"
}

resource "azurerm_role_assignment" "Default_KeyVault_SystemsEngineering" {
  scope                = "/subscriptions/${data.azurerm_subscription.this.subscription_id}"
  role_definition_name = "Key Vault Certificates Officer"
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