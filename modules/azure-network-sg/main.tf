########################
# Security groups
#########################
# servers sg
# shared servers
# Network F5 ADCs  ata/atb-adc01 network_f5
resource "azurerm_application_security_group" "ng_network_f5_asg" {
  name                = "network-f5-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_f5_nsg" {
  name                = "network-f5-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_f5_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_f5_rules_prefix_mgmnt : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_f5_nsg.name
}

#external
resource "azurerm_application_security_group" "ng_network_f5_external_asg" {
  name                = "network-f5-external-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_f5_external_nsg" {
  name                = "network-f5-external-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_f5_rules_external_prefix" {
  for_each                    = { for idx, record in local.ng_network_f5_rules_prefix_external : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_f5_external_nsg.name
}
#internal

resource "azurerm_application_security_group" "ng_network_f5_internal_asg" {
  name                = "network-f5-internal-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_f5_internal_nsg" {
  name                = "network-f5-internal-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_f5_rules_internal_prefix" {
  for_each                    = { for idx, record in local.ng_network_f5_rules_prefix_internal : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_f5_internal_nsg.name
}

#experting nsg for f5




# Network Logic Monitor ata/atb-inlmo01  network_logicmonitor
resource "azurerm_application_security_group" "ng_network_logicmonitor_asg" {
  name                = "network-logicmonitor-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_logicmonitor_nsg" {
  name                = "network-logicmonitor-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_logicmonitor_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_logicmonitor_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_logicmonitor_nsg.name
}




# Network Palo Ato Firewall ata/atb-fw01  network_paloalto
resource "azurerm_application_security_group" "ng_network_paloalto_asg" {
  name                = "network-paloalto-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_paloalto_nsg" {
  name                = "network-paloalto-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_paloalto_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_paloalto_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_paloalto_nsg.name
}


# palo all access
resource "azurerm_network_security_group" "ng_network_paloalto_int_nsg" {
  name                = "network-paloalto-int-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_paloalto_int_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_paloalto_rules_prefix_all_access : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_paloalto_int_nsg.name
}




# NG Global Web Server   ata/atb-ingws01  ng_globalweb
resource "azurerm_application_security_group" "ng_globalweb_asg" {
  name                = "ng-globalweb-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_globalweb_nsg" {
  name                = "ng-globalweb-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_globalweb_rules_prefix" {
  for_each                    = { for idx, record in local.ng_globalweb_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_globalweb_nsg.name
}



# Systems Domain Controller ata/atb-indco01  systems_domaincontroller
resource "azurerm_application_security_group" "ng_systems_domaincontroller_asg" {
  name                = "systems-domaincontroller-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_systems_domaincontroller_nsg" {
  name                = "systems-domaincontroller-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_systems_domaincontroller_rules_prefix" {
  for_each                    = { for idx, record in local.ng_systems_domaincontroller_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_systems_domaincontroller_nsg.name
}



# Tools Thousand Eyes Agent DMZ  ata/atb-inted01  network_thousandeyesagentdmz
resource "azurerm_application_security_group" "ng_network_thousandeyesagentdmz_asg" {
  name                = "network-thousandeyesagentdmz-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_thousandeyesagentdmz_nsg" {
  name                = "network-thousandeyesagentdmz-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_thousandeyesagentdmz_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_thousandeyesagentdmz_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_thousandeyesagentdmz_nsg.name
}



#Tools Thousand Eyes Agent Internal  ata/atb-intei01  network_thousandeyesagentinternal
resource "azurerm_application_security_group" "ng_network_thousandeyesagentinternal_asg" {
  name                = "network-thousandeyesagentinternal-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_network_thousandeyesagentinternal_nsg" {
  name                = "network-thousandeyesagentinternal-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_thousandeyesagentinternal_rules_prefix" {
  for_each                    = { for idx, record in local.ng_network_thousandeyesagentinternal_rules_prefix : idx => record }
  name                        = each.value.name
  priority                    = format("%g", each.key + 1000)
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.sg_resource_group
  network_security_group_name = azurerm_network_security_group.ng_network_thousandeyesagentinternal_nsg.name
}



# NG BI Datamart Server ata/atb-inbid01  ng_bidatamart_asg
resource "azurerm_application_security_group" "ng_bidatamart_asg" {
  name                = "ng-bidatamart-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}

resource "azurerm_network_security_group" "ng_bidatamart_nsg" {
  name                = "ng-bidatamart-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "ng_network_bidatamart_rules_prefix" {
  for_each                                   = { for idx, record in local.ng_network_bidatamart_rules_prefix : idx => record }
  name                                       = each.value.name
  priority                                   = format("%g", each.key + 1000)
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  destination_port_range                     = each.value.destination_port_range
  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
  resource_group_name                        = var.sg_resource_group
  network_security_group_name                = azurerm_network_security_group.ng_bidatamart_nsg.name
  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
}




#SphosServersSG"
resource "azurerm_application_security_group" "ng_network_sophos-servers-asg" {
  name                = "tools-sophos-servers-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "ng_sophos_servers_nsg" {
  name                = "sophos-servers-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
#resource "azurerm_network_security_rule" "ng_network_sophos-servers_rules_prefix" {
#  for_each                                   = { for idx, record in local.ng_network_sophos-servers_rules_prefix : idx => record }
#  name                                       = each.value.name
#  priority                                   = format("%g", each.key + 1000)
#  direction                                  = each.value.direction
#  access                                     = each.value.access
#  protocol                                   = each.value.protocol
#  source_port_range                          = each.value.source_port_range
#  destination_port_range                     = each.value.destination_port_range
#  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
#  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
#  resource_group_name                        = var.sg_resource_group
#  network_security_group_name                = azurerm_network_security_group.ng_sophos_servers_nsg.name
#  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
#  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
#}




#nested_intdnsserverssg
resource "azurerm_application_security_group" "ng_network_intdnsserver_asg" {
  name                = "systems-nameserverinternal-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}


#BMPCSServersSG
resource "azurerm_application_security_group" "ng_network_bmpc_sservers_sg_asg" {
  name                = "tools-bmcpatrolcentral-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "tools_bmcmonitoring_nsg" {
  name                = "tools-bmcmonitoring-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "tools_bmcmonitoring_nsg_rules_prefix" {
  for_each                                   = { for idx, record in local.tools_bmcmonitoring_nsg_rules_prefix : idx => record }
  name                                       = each.value.name
  priority                                   = format("%g", each.key + 1000)
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  destination_port_range                     = each.value.destination_port_range
  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
  resource_group_name                        = var.sg_resource_group
  network_security_group_name                = azurerm_network_security_group.tools_bmcmonitoring_nsg.name
  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
}


#jumpserverssg
resource "azurerm_application_security_group" "ng_network_jumpservers_asg" {
  name                = "tools-jump-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}


#"clusteralbsecuritygroup" 

resource "azurerm_application_security_group" "ng_network_cluster_albsecurity_group_asg" {
  name                = "network-cluster-albsecurity-group-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}

#inmailsgdmz
resource "azurerm_application_security_group" "ng_network_cluster_inmailsgdmz_asg" {
  name                = "systems-keriomail-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
#noconntrackf5_sg
resource "azurerm_application_security_group" "ng_network_noconntrackf5_asg" {
  name                = "network-noconntrackf5-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}

#"cluster_dbmonserverssg"
resource "azurerm_application_security_group" "ng_network_cluster_dbmonservers_asg" {
  name                = "tools-databasemonitor-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_group" "tools-databasemonitor-nsg" {
  name                = "tools-databasemonitor-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "tools-databasemonitor_rules_prefix" {
  for_each                                   = { for idx, record in local.tools-databasemonitor_rules_prefix : idx => record }
  name                                       = each.value.name
  priority                                   = format("%g", each.key + 1000)
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  destination_port_range                     = each.value.destination_port_range
  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
  resource_group_name                        = var.sg_resource_group
  network_security_group_name                = azurerm_network_security_group.tools-databasemonitor-nsg.name
  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
}



#ftpintserverssg
resource "azurerm_application_security_group" "ng_network_ftpintserver_asg" {
  name                = "systems-ftpinternal-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}




# internal core
resource "azurerm_application_security_group" "cluster_internal_servers_asg" {
  name                = "cluster-internal-servers-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}

resource "azurerm_network_security_group" "cluster_internal_servers_nsg" {
  name                = "cluster-internal-servers-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "cluster_internal_servers_rules_prefix" {
  for_each                                   = { for idx, record in local.ng_cluster_internal_servers_rules_prefix : idx => record }
  name                                       = each.value.name
  priority                                   = format("%g", each.key + 1000)
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  destination_port_range                     = each.value.destination_port_range
  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
  resource_group_name                        = var.sg_resource_group
  network_security_group_name                = azurerm_network_security_group.cluster_internal_servers_nsg.name
  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
}



## internal dmz
resource "azurerm_application_security_group" "cluster_dmz_servers_asg" {
  name                = "cluster-dmz-servers-asg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}

resource "azurerm_network_security_group" "cluster_dmz_servers_nsg" {
  name                = "cluster-dmz-servers-nsg"
  location            = var.sg_location
  resource_group_name = var.sg_resource_group
}
resource "azurerm_network_security_rule" "cluster_dmz_servers_rules_prefix" {
  for_each                                   = { for idx, record in local.ng_cluster_dmz_servers_rules_prefix : idx => record }
  name                                       = each.value.name
  priority                                   = format("%g", each.key + 1000)
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  destination_port_range                     = each.value.destination_port_range
  source_address_prefix                      = (each.value.source_address_prefix != "" ? each.value.source_address_prefix : null)
  destination_address_prefix                 = (each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null)
  resource_group_name                        = var.sg_resource_group
  network_security_group_name                = azurerm_network_security_group.cluster_dmz_servers_nsg.name
  source_application_security_group_ids      = (length(each.value.source_application_security_group_ids) != 0 ? each.value.source_application_security_group_ids : [])
  destination_application_security_group_ids = (length(each.value.destination_application_security_group_ids) != 0 ? each.value.destination_application_security_group_ids : [])
}



## output -> save to vault -> asg and nsg


#nested_intdnsserverssg
#resource "azurerm_application_security_group" "ng_network_intdnsserver_asg" {


resource "azurerm_key_vault_secret" "systems-nameserverinternal-asg" {
  name         = "systems-nameserverinternal-asg"
  value        = azurerm_application_security_group.ng_network_intdnsserver_asg.id
  key_vault_id = var.key_vault_id
}

#BMPCSServersSG
#resource "azurerm_application_security_group" "ng_network_bmpc_sservers_sg_asg" {
resource "azurerm_key_vault_secret" "tools-bmcpatrolcentral-asg" {
  name         = "tools-bmcmonitoring-asg"
  value        = azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "tools-bmcpatrolcentral-nsg" {
  name         = "tools-bmcmonitoring-nsg"
  value        = azurerm_network_security_group.tools_bmcmonitoring_nsg.id
  key_vault_id = var.key_vault_id
}



#jumpserverssg
#resource "azurerm_application_security_group" "ng_network_jumpservers_asg" {
resource "azurerm_key_vault_secret" "tools-jump-asg" {
  name         = "tools-jump-asg"
  value        = azurerm_application_security_group.ng_network_jumpservers_asg.id
  key_vault_id = var.key_vault_id
}

#"clusteralbsecuritygroup"
#resource "azurerm_application_security_group" "ng_network_cluster_albsecurity_group_asg" {
resource "azurerm_key_vault_secret" "network-cluster-albsecurity-group-asg" {
  name         = "network-cluster-albsecurity-group-asg"
  value        = azurerm_application_security_group.ng_network_cluster_albsecurity_group_asg.id
  key_vault_id = var.key_vault_id
}

#inmailsgdmz
#resource "azurerm_application_security_group" "ng_network_cluster_inmailsgdmz_asg" {


resource "azurerm_key_vault_secret" "systems-keriomail-asg" {
  name         = "systems-keriomail-asg"
  key_vault_id = var.key_vault_id
  value        = azurerm_application_security_group.ng_network_cluster_inmailsgdmz_asg.id
}

#noconntrackf5_sg
#resource "azurerm_application_security_group" "ng_network_noconntrackf5_asg" {
resource "azurerm_key_vault_secret" "network-noconntrackf5-asg" {
  name         = "network-noconntrackf5-asg"
  key_vault_id = var.key_vault_id
  value        = azurerm_application_security_group.ng_network_noconntrackf5_asg.id
}


#"cluster_dbmonserverssg"
#resource "azurerm_application_security_group" "ng_network_cluster_dbmonservers_asg" {
resource "azurerm_key_vault_secret" "tools-databasemonitor-asg" {
  name         = "tools-databasemonitor-asg"
  key_vault_id = var.key_vault_id
  value        = azurerm_application_security_group.ng_network_cluster_dbmonservers_asg.id
}

resource "azurerm_key_vault_secret" "tools-databasemonitor-nsg" {
  name         = "tools-databasemonitor-nsg"
  key_vault_id = var.key_vault_id
  value        = azurerm_network_security_group.tools-databasemonitor-nsg.id
}

#ftpintserverssg
#resource "azurerm_application_security_group" "ng_network_ftpintserver_asg" {


resource "azurerm_key_vault_secret" "systems-ftpinternal-asg" {
  name         = "systems-ftpinternal-asg"
  key_vault_id = var.key_vault_id
  value        = azurerm_application_security_group.ng_network_ftpintserver_asg.id
}



# Network F5 ADCs  ata/atb-adc01 network_f5
resource "azurerm_key_vault_secret" "network-f5-asg" {
  name         = "network-f5-asg"
  value        = azurerm_application_security_group.ng_network_f5_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-f5-nsg" {
  name         = "network-f5-nsg"
  value        = azurerm_network_security_group.ng_network_f5_nsg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-f5-external-nsg" {
  name         = "network-f5-external-nsg"
  value        = azurerm_network_security_group.ng_network_f5_external_nsg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-f5-internal-nsg" {
  name         = "network-f5-internal-nsg"
  value        = azurerm_network_security_group.ng_network_f5_internal_nsg.id
  key_vault_id = var.key_vault_id
}


# Network Logic Monitor ata/atb-inlmo01  network-logicmonitor
resource "azurerm_key_vault_secret" "network-logicmonitor-asg" {
  name         = "network-logicmonitor-asg"
  value        = azurerm_application_security_group.ng_network_logicmonitor_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-logicmonitor-nsg" {
  name         = "network-logicmonitor-nsg"
  value        = azurerm_network_security_group.ng_network_logicmonitor_nsg.id
  key_vault_id = var.key_vault_id
}
# Network Palo Ato Firewall ata/atb-fw01  network-paloalto
resource "azurerm_key_vault_secret" "network-paloalto-asg" {
  name         = "network-paloalto-asg"
  value        = azurerm_application_security_group.ng_network_paloalto_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-paloalto-nsg" {
  name         = "network-paloalto-nsg"
  value        = azurerm_network_security_group.ng_network_paloalto_nsg.id
  key_vault_id = var.key_vault_id
}
# NG Global Web Server   ata/atb-ingws01  ng_globalweb
resource "azurerm_key_vault_secret" "ng-globalweb-asg" {
  name         = "ng-globalweb-asg"
  value        = azurerm_application_security_group.ng_globalweb_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "ng-globalweb-nsg" {
  name         = "ng-globalweb-nsg"
  value        = azurerm_network_security_group.ng_globalweb_nsg.id
  key_vault_id = var.key_vault_id
}
# Systems Domain Controller ata/atb-indco01  systems_domaincontroller
resource "azurerm_key_vault_secret" "systems-domaincontroller-asg" {
  name         = "systems-domaincontroller-asg"
  value        = azurerm_application_security_group.ng_systems_domaincontroller_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "systems-domaincontroller-nsg" {
  name         = "systems-domaincontroller-nsg"
  value        = azurerm_network_security_group.ng_systems_domaincontroller_nsg.id
  key_vault_id = var.key_vault_id
}
# Tools Thousand Eyes Agent DMZ  ata/atb-inted01  network_thousandeyesagentdmz
resource "azurerm_key_vault_secret" "network-thousandeyesagentdmz-asg" {
  name         = "network-thousandeyesagentdmz-asg"
  value        = azurerm_application_security_group.ng_network_thousandeyesagentdmz_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-thousandeyesagentdmz-nsg" {
  name         = "network-thousandeyesagentdmz-nsg"
  value        = azurerm_network_security_group.ng_network_thousandeyesagentdmz_nsg.id
  key_vault_id = var.key_vault_id
}
#Tools Thousand Eyes Agent Internal  ata/atb-intei01  network_thousandeyesagentinternal
resource "azurerm_key_vault_secret" "network-thousandeyesagentinternal-asg" {
  name         = "network-thousandeyesagentinternal-asg"
  value        = azurerm_application_security_group.ng_network_thousandeyesagentinternal_asg.id
  key_vault_id = var.key_vault_id
}
resource "azurerm_key_vault_secret" "network-thousandeyesagentinternal-nsg" {
  name         = "network-thousandeyesagentinternal-nsg"
  value        = azurerm_network_security_group.ng_network_thousandeyesagentinternal_nsg.id
  key_vault_id = var.key_vault_id
}

# NG BI Datamart Server ata/atb-inbid01  ng_bidatamart_asg
resource "azurerm_key_vault_secret" "ng-bidatamart-asg" {
  name         = "ng-bidatamart-asg"
  value        = azurerm_application_security_group.ng_bidatamart_asg.id
  key_vault_id = var.key_vault_id
}
#ng_bidatamart_nsg"
resource "azurerm_key_vault_secret" "ng-bidatamart-nsg" {
  name         = "ng-bidatamart-nsg"
  value        = azurerm_network_security_group.ng_bidatamart_nsg.id
  key_vault_id = var.key_vault_id
}
#cluster_internal_servers-asg"
resource "azurerm_key_vault_secret" "cluster-internal-servers-asg" {
  name         = "cluster-internal-servers-asg"
  value        = azurerm_application_security_group.cluster_internal_servers_asg.id
  key_vault_id = var.key_vault_id
}
#cluster_internal_servers-nsg


resource "azurerm_key_vault_secret" "cluster-internal-servers-nsg" {
  name         = "cluster-internal-servers-nsg"
  value        = azurerm_network_security_group.cluster_internal_servers_nsg.id
  key_vault_id = var.key_vault_id
}
#cluster_dmz_servers-asg


resource "azurerm_key_vault_secret" "cluster-dmz-servers-asg" {
  name         = "cluster-dmz-servers-asg"
  value        = azurerm_application_security_group.cluster_dmz_servers_asg.id
  key_vault_id = var.key_vault_id
}
#cluster_dmz_servers-nsg


resource "azurerm_key_vault_secret" "cluster-dmz-servers-nsg" {
  name         = "cluster-dmz-servers-nsg"
  value        = azurerm_network_security_group.cluster_dmz_servers_nsg.id
  key_vault_id = var.key_vault_id
}