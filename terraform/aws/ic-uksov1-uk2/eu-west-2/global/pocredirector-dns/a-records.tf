module "pocredirector_uk2" {
  source  = "spacelift.io/incontact/pocredirector-dns-a/default"
  version = "0.0.3"

  # instance_name = "pocredirector" # Default
  area_id       = "uk2"
  nlb_addresses = ["10.232.161.254", "10.232.163.254", "10.232.165.254"]
  domain        = local.domain
}
