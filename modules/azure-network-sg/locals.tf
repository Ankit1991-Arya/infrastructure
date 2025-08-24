locals {
  ng_network_f5_rules_prefix_mgmnt = [
    {
      name                       = "all-0.0.0.0-0"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "ssh-22"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "https-443"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_network_f5_rules_prefix_external = [
    {
      name                       = "all-0.0.0.0-0"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "ssh-22"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "https-443"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_network_f5_rules_prefix_internal = [
    {
      name                       = "all-0.0.0.0-0"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "ssh-22"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "https-443"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]

  ng_network_logicmonitor_rules_prefix = [
    {
      name                       = "vpn_ips"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/19"
      destination_address_prefix = "*"
    },
    {
      name                       = "office_ip_space"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.27.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "la2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.23.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "dal"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "eu"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "SGP"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.29.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-1"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.64/26"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.128/27"
      destination_address_prefix = "*"
    },
    {
      name                       = "LAB"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.20.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "DMZ-Subnet"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.dmz_vnet_address_space
      destination_address_prefix = "*"
    },
    {
      name                       = "DMZ-Addon-Subnet"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.200.0/22"
      destination_address_prefix = "*"
    },
    {
      name                       = "Udp-514"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "514"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "Tcp-514"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "514"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "ip-10-209-0-0"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
    },
    {
      name                       = "BMC-Discovery"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.8.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "CDR"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.10.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "TESTVPN"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.11.79/32"
      destination_address_prefix = "*"
    },
    {
      name                       = "172.16.0.0-12"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "10.0.0.0-8"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "192.168.0.0-16"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
    {
      name                       = "tcp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "Udp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "udp-443"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "tcp-80"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_network_paloalto_rules_prefix_all_access = [
    {
      name                       = "all_in_alow"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "all_out_allow"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    }
  ]

  ng_network_paloalto_rules_prefix = [
    {
      name                       = "172.19.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "TCP-22-10.21.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "TCP-443-10.21.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "10.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "ICMP-10.21.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "ESP"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Esp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "TCP-4500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4500"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "UDP-500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "500"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "0.0.0.0-0-2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "0.0.0.0-0"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
  ]
  #  (Used for PA Untrust)
  global_security_groups_no_conntrack_untrust_sg = [
    {
      name                       = "ESP"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Esp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "TCP-4500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "4500"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "UDP-500"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "500"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "0.0.0.0-0"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
  }, ]
  #GlobalSecurityGroups no_conntrack_sg
  global_securityGroups_no_conntrack_sg = [
    {
      name                       = "0.0.0.0-0"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "0.0.0.0-0"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
  ]
  ng_globalweb_rules_prefix = [
    {
      name                       = "vpn_ips"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/19"
      destination_address_prefix = "*"
    },
    {
      name                       = "office_ip_space"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.27.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "la2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.23.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "dal"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "eu"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "Core-VPC"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.core_vnet_address_space
      destination_address_prefix = "*"
    },
    {
      name                       = "AUS-Core"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
    },
    {
      name                       = "BMC-DIS"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.8.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "10.209.0.0-17"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
    },
    {
      name                       = "BMC-Discovery"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.8.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "CDR"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.10.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "172.16.0.0-12"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
    {
      name                       = "tcp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "udp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "tcp-443"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "tcp-21"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "21"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "tcp-80"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "DC-Subnet"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.209.0.0/17"
      }, {
      name                       = "Core-VPC-10.209.128.0-18"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.209.128.0/18"
      }, {
      name                       = "Core-VPC-10.4.96.0-21"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.4.96.0/21"
      }, {
      name                       = "BMC-DIS-205.214.8.0-24"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "205.214.8.0/24"
      }, {
      name                       = "Core-VPC-generic"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = var.core_vnet_address_space
      }, {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_systems_domaincontroller_rules_prefix = [
    {
      name                       = "Tcp-389"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Udp-389"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "tcp-636"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "636"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-tdp-88"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "88"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-udp-88"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "88"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "dnsTcp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "dns-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "smbTcp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "smb-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "smtp-tcp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "25"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "rpc-tcp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "135"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "rpc-tcp-1025"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1025-5000"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "rpc-tcp-49152"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "49152-65535"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "rpc-tcp-5722"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5722"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Windows-Time-udp-123"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-PWS-MGMT-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "464"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Group-Policy-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "49152-65535"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Netlogon-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "138"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-tcp-9389"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "MADCAP-udp"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "67"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "MADCAP-udp-2535"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "2535"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "NetBIOS-udp-137"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "137"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Netlogon-tcp-139"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "139"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-udp-749"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "749-750"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "Kerberos-tcp-749"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "749-750"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "RDP-tcp-3389"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "RDP-udp-3389"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "VPN-IPs-10.21.0.0-19"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/19"
      destination_address_prefix = "*"
      }, {
      name                       = "Aus-Data-Center-IP-10.209.0.0-17"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
      }, {
      name                       = "Office-IP-172.27.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.27.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "Oregon-AWS-IP-172.25.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.25.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "LA-IP-172.23.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.23.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "DAL-IP-172.19.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "EU-IP-172.21.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.21.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "SGP-172.29.0.0-16"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.29.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "HKO-1-216.20.228.64-26"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.64/26"
      destination_address_prefix = "*"
      }, {
      name                       = "HKO-2-216.20.228.128-27"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.128/27"
      destination_address_prefix = "*"
      }, {
      name                       = "DMZ-Subnet"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.dmz_vnet_address_space
      destination_address_prefix = "*"
      }, {
      name                       = "DMZ-Addon-Subnet-10.209.200.0-22"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.200.0/22"
      destination_address_prefix = "*"
      }, {
      name                       = "BMC-Discovery-205.214.8.0-24"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.8.0/24"
      destination_address_prefix = "*"
      }, {
      name                       = "CDR-205.214.10.0-24"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.10.0/24"
      destination_address_prefix = "*"
      }, {
      name                       = "CDR-10.209.0.0-17"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
      }, {
      name                       = "172.16.0.0-12"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
      }, {
      name                       = "10.0.0.0-8"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
      }, {
      name                       = "192.168.0.0-16"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
      }, {
      name                       = "Tcp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "Udp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "Tcp-443"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "Tcp-80"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "BMC-DIS-205.214.8.0-24"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "205.214.8.0/24"
      }, {
      name                                       = "10.0.0.0-8-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.16.0.0-12-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]
  ng_network_thousandeyesagentdmz_rules_prefix = [
    {
      name                       = "vpn_ips"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/19"
      destination_address_prefix = "*"
    },
    {
      name                       = "office_ip_space"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.27.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "la2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.23.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "dal"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "eu"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "SGP"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.29.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-1"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.64/26"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.128/27"
      destination_address_prefix = "*"
    },
    {
      name                       = "LAB"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.20.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "Core-VPC"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.core_vnet_address_space
      destination_address_prefix = "*"
      }, {
      name                       = "udp-514"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "514"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "tcp-445"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "10.209.0.0-17"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
      }, {
      name                       = "BMC-Discovery-205.214.8.0-24"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.8.0/24"
      destination_address_prefix = "*"
      }, {
      name                       = "CDR-205.214.10.0-24"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.10.0/24"
      destination_address_prefix = "*"
      }, {
      name                       = "172.16.0.0-12"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
      }, {
      name                       = "10.0.0.0-8"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
      }, {
      name                       = "192.168.0.0-16"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
      }, {
      name                       = "tcp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "udp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "tcp-443"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "tcp-80"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_network_thousandeyesagentinternal_rules_prefix = [
    {
      name                       = "vpn_ips"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.21.0.0/19"
      destination_address_prefix = "*"
    },
    {
      name                       = "office_ip_space"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.27.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "la2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.23.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "dal"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.19.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "eu"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.21.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "SGP"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.29.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-1"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.64/26"
      destination_address_prefix = "*"
    },
    {
      name                       = "HKO-2"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "216.20.228.128/27"
      destination_address_prefix = "*"
    },
    {
      name                       = "LAB"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.20.0.0/16"
      destination_address_prefix = "*"
      }, {
      name                       = "DMZ-Subnet"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.dmz_vnet_address_space
      destination_address_prefix = "*"
      }, {
      name                       = "udp-514"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "514"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
      }, {
      name                       = "tcp-445"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "BMC-Discovery-10.209.0.0-17"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.209.0.0/17"
      destination_address_prefix = "*"
      }, {
      name                       = "CDR205.214.10.0-24"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "205.214.10.0/24"
      destination_address_prefix = "*"
      }, {
      name                       = "172.16.0.0-12"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
      }, {
      name                       = "10.0.0.0-8"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
      }, {
      name                       = "192.168.0.0-16"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
      }, {
      name                       = "tcp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "udp-53"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "tcp-443"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
      }, {
      name                       = "tcp-80"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "0.0.0.0/0"
    },
    {
      name                       = "10.0.0.0-8-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "172.16.0.0-12-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "172.16.0.0/12"
    },
    {
      name                       = "192.168.0.0-16-all"
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.0.0/16"
    },
  ]
  ng_network_bidatamart_rules_prefix = [
    {
      name                                       = "SMB"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "NICE-VPN-GP-Pool"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.40.0/22"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "WMI"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "49154"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-135"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "135"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "SQL"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1433"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.23.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.23.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.19.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.19.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.21.0.0-19"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.0.0/19"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.228.128-27"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.128/27"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "CDR"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.228.64-26"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.64/26"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "BMC_Discovery"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.8.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.209.0.0-17"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.209.0.0/17"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_SophosServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8194"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_sophos-servers-asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG_2059"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "2059"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG_135"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "135"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG_445"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_DomainControllerSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_systems_domaincontroller_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.244.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.244.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.248.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.248.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-443"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-80"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Udp-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.0.0.0-8"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.16.0.0-12"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]
  ng_network_sophos-servers_rules_prefix = [
    {
      name                                       = "172.23.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.23.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.27.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.27.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.29.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.29.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG_2059"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "2059"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG_445"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG-3"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_DomainControllerSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_systems_domaincontroller_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_SophosServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_sophos-servers-asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_IntDNSServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_intdnsserver_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.0.0.0-8"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]

  ng_cluster_dmz_servers_rules_prefix = [
    {
      name                                       = "LA2-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.23.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Office-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.27.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "DAL-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.19.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "EU-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.21.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VPN-IPs"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.0.0/19"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VDI-1"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.80.52.0/23"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VDI-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.80.54.0/23"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VDI-3"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.80.56.0/23"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VDI-4"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.80.58.0/23"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "corppcijs-1"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.144/32"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "corppcijs-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.145/32"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "BMC-Discovery-and-Capacity"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.8.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_Cluster_PCI_DMZ_Server_SG-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.cluster_dmz_servers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_ClusterALBSecurityGroup"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_cluster_albsecurity_group_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "TCP-443"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-80"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "UDP-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Tcp-21-22"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "21-22"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "DC Nets"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.0.0.0-8"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "205.214.30.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "205.214.30.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

    {
      name                                       = "207.166.100.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.100.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.66.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.66.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.67.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.67.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.68.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.68.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.77.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.77.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

    {
      name                                       = "207.166.76.64-26"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.76.64/26"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.79.128-28"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.79.128/28"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.79.144-28"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.79.144/28"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.80.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.80.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.86.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.86.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.92.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.92.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.94.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.94.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.95.0-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.0/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.95.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.238.0-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.238.0/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

    {
      name                                       = "216.20.238.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.238.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.246.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.246.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.250.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.250.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_Cluster_PCI_DMZ_Server_SG"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.cluster_dmz_servers_asg.id]
    },
    {
      name                                       = "nested_ClusterALBSecurityGroup_443"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.ng_network_cluster_albsecurity_group_asg.id]
    },
    {
      name                                       = "nested_ClusterALBSecurityGroup_80"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.ng_network_cluster_albsecurity_group_asg.id]
    },
    {
      name                                       = "nested_ClusterALBSecurityGroup_8800"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8800"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.ng_network_cluster_albsecurity_group_asg.id]
      }, {
      name                                       = "10.0.0.0-8-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.16.0.0-12-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

  ]


  ng_cluster_internal_servers_rules_prefix = [
    #Cluster_PCI_Core_Server_SG
    {
      name                                       = "LA2-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.23.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Office-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.27.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "DAL-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.19.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "EU-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.21.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "VPN-IPs"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.0.0/19"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "NICE-Global-Protect"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.40.0/22"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "corppcijs-1"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.144/32"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "corppcijs-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.145/32"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "BMC-Discovery-and-Capacity"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.8.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "HKO-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.64/26"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "HKO-IP-Space-1"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.128/27"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Australia-Data-Center-Ne"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.209.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Singapore-IP-Space"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.29.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_NoConnTrackF5_SG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_noconntrackf5_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_MailDirectorServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "25"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_noconntrackf5_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BidServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1433"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_noconntrackf5_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_SophosServersSG_8149"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8149"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_sophos-servers-asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG_3389"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "3389"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG_1433"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1433"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG_1"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1450"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersS_445"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG_8802"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8802"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG_9300-9301"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "9300-9301"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_JumpServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "1434"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_jumpservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_Cluster_PCI_Core_Server_SG-2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.cluster_internal_servers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_DBMonServersSG2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1433-1434"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_cluster_dbmonservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_DBMonServersSG23"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1450"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_cluster_dbmonservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_DBMonServersSG4"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "1433"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_cluster_dbmonservers_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_FTPINTServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "21-22"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_ftpintserver_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_FTPINTServersSG2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_ftpintserver_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_FTPINTServersSG3"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_ftpintserver_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "2059"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG23"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "135"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_BMPCSServersSG2"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = ""
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "git_rule_in_172"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "5985-5986"
      source_address_prefix                      = "172.31.128.0/20"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "git_rule_in_10"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "5985-5986"
      source_address_prefix                      = "10.0.0.0/8"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "CORPWHDB01"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = "205.214.10.190/32"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "MCR_WFO"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.221.24.0/21"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "CORPWHDB02"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1433"
      source_address_prefix                      = "10.80.24.66"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "All_SSL_Out"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "All_Http_Out"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "All_DNS"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "All_DNS_Out"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "All_FTP_Out"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "21-22"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "DC_Nets"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "Data_center_Nets"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "LA_Nets"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.23.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "DAL_Nets"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.19.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

    {
      name                                       = "205.214.30.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "205.214.30.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "205.214.8.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "205.214.8.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.100.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.100.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.66.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.66.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.67.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.67.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.68.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.68.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.77.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.77.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.76.64-26"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.76.64/26"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.79.128-28"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.79.128/28"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.79.144-28"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.79.144/28"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.80.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.80.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.86.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.86.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.92.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.92.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.94.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.94.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.95.0-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.0/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "207.166.95.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.238.0-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.238.0/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.238.128-25"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.238.128/25"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.246.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.246.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.244.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.244.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.248.0-24"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.248.0/24"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.250.0-23"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "216.20.250.0/23"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "nested_Cluster_PCI_Core_Server_SG"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.cluster_internal_servers_asg.id]
    },
    {
      name                                       = "nested_BMPCSServersSG4"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "2059"
      source_address_prefix                      = "*"
      destination_address_prefix                 = ""
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.ng_network_bmpc_sservers_sg_asg.id]
    },
    {
      name                                       = "10.0.0.0-8-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.16.0.0-12-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]
  tools-databasemonitor_rules_prefix = [
    #Cluster_PCI_Core_Server_SG
    {
      name                                       = "172.19.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.19.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.209.0.0-17"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.209.0.0/17"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
      }, {
      name                                       = "10.21.0.0-19"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.0.0/19"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "205.214.10.0-24"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.20.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.20.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "205.214.8.0-24"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.8.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.21.40.0-22"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.40.0/22"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.27.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.27.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.209.200.0-22"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.209.200.0/22"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.5.40.0-21"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.5.40.0/21"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.21.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.21.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.228.64-26"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.64/26"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "smbTcp"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "445"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []

    },
    {
      name                                       = "1450"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1450"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "1434"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "1434"
      source_address_prefix                      = "0.0.0.0/0"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "10.0.0.0-8-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "10.0.0.0/8"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.16.0.0-12-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "192.168.0.0-16-all"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "0.0.0.0-443"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "0.0.0.0-80"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "0.0.0.0-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "0.0.0.0-53-u"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "lax-inmai01-SMTP"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "24"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.11/32"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "lax-inmai01-SMTPS"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "465"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "207.166.95.11/32"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]

  tools_bmcmonitoring_nsg_rules_prefix = [
    {
      name                                       = "172.23.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.23.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.29.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.29.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.19.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.19.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.21.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.21.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "172.20.0.0-16"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "172.20.0.0/16"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {

      name                                       = "NICEGlobalProtect"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "10.21.40.0/22"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "BMC-Discovery"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.8.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "205.214.10.0-24"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "205.214.10.0/24"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "216.20.228.128-27"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "216.20.228.128/27"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    #{
    #  name                       = "nested_ BMPCSServersSG"
    #  direction                  = "Inbound"
    #  access                     = "Allow"
    #  protocol                   = "*"
    #  source_port_range          = "*"
    #  destination_port_range     = "*"
    #  source_address_prefix      = "BMPCSServersSG"
    #  destination_address_prefix = "*"
    #      source_application_security_group_ids      = []
    #      destination_application_security_group_ids = []
    #},
    #{
    #  name                       = "nested_ SophosServersSG"
    #  direction                  = "Inbound"
    #  access                     = "Allow"
    #  protocol                   = "TCP"
    #  source_port_range          = "*"
    #  destination_port_range     = "8194"
    #  source_address_prefix      = "SophosServersSG"
    #  destination_address_prefix = "*"
    #      source_application_security_group_ids      = []
    #      destination_application_security_group_ids = []
    #},
    #{
    #  name                       = "nested_ BMINTServersSG"
    #  direction                  = "Inbound"
    #  access                     = "Allow"
    #  protocol                   = "*"
    #  source_port_range          = "*"
    #  destination_port_range     = "*"
    #  source_address_prefix      = "BMINTServersSG"
    #  destination_address_prefix = "*"
    #      source_application_security_group_ids      = []
    #      destination_application_security_group_ids = []
    #},
    #{
    #  name                       = "nested_ DomainControllerSG"
    #  direction                  = "Inbound"
    #  access                     = "Allow"
    #  protocol                   = "*"
    #  source_port_range          = "*"
    #  destination_port_range     = "*"
    #  source_address_prefix      = "DomainControllerSG"
    #  destination_address_prefix = "*"
    #      source_application_security_group_ids      = []
    #      destination_application_security_group_ids = []
    #},
    {
      name                                       = "TCP-443"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "443"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "TCP-80"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "80"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "UDP-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Udp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "TCP-53"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      source_port_range                          = "*"
      destination_port_range                     = "53"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "0.0.0.0/0"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },

    {
      name                                       = "192.168.0.0-16"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "192.168.0.0/16"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
    {
      name                                       = "r172.16.0.0-12"
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "172.16.0.0/12"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    },
  ]
}