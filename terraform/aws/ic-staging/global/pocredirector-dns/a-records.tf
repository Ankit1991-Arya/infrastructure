# These modules create A records for each of the pocredirector deployments in the environment
# After adding a deployment of pocredirector somewhere, adding a new module here will create
# its A records and enable the module to be cited in the naptr-srv-records.tf file.
module "pocredirector_na1" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  # area_id = "na1" # Default
  # port = "5060" # Default
  nlb_addresses = ["10.9.80.254", "10.9.82.254", "10.9.84.254"]
  domain        = local.domain
}
