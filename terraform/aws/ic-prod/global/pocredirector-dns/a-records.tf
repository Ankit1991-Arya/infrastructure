# These modules create A records for each of the pocredirector deployments in the environment
# After adding a deployment of pocredirector somewhere, adding a new module here will create
# its A records and enable the module to be cited in the naptr-srv-records.tf file.
module "pocredirector_na1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  # area_id = "na1" # Default
  # port = "5060" # Default
  nlb_addresses = ["10.5.161.254", "10.5.163.254", "10.5.165.254"]
  domain        = local.domain
}

module "pocredirector_ca1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id = "ca1"
  # port = "5060" # Default
  nlb_addresses = ["10.5.209.254", "10.5.211.254", "10.5.213.254"]
  domain        = local.domain
}

module "pocredirector_eu1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id = "eu1"
  # port = "5060" # Default
  nlb_addresses = ["10.5.177.254", "10.5.179.253", "10.5.181.254"]
  domain        = local.domain
}

module "pocredirector_uk1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id = "uk1"
  # port = "5060" # Default
  nlb_addresses = ["10.5.225.254", "10.5.227.254", "10.5.229.254"]
  domain        = local.domain
}

module "pocredirector_au1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id = "au1"
  # port = "5060" # Default
  nlb_addresses = ["10.5.193.254", "10.5.195.254", "10.5.197.254"]
  domain        = local.domain
}

module "pocredirector_jp1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id = "jp1"
  # port = "5060" # Default
  nlb_addresses = ["10.5.241.254", "10.5.243.254", "10.5.245.254"]
  domain        = local.domain
}
