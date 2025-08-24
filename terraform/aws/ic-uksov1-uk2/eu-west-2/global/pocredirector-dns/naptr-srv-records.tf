# These modules create a NAPTR and SRV for each POP where SBCs are found
# Adding a new pop is as simple as adding a new mapping to the locals section below
locals {
  pops = {
    # Manchester, UK
    ma4 = {
      primary   = module.pocredirector_uk2
      secondary = null
      tertiary  = null
    }
    # London, UK
    ld7 = {
      primary   = module.pocredirector_uk2
      secondary = null
      tertiary  = null
    }
  }
}

module "pocredirector" {
  for_each = local.pops
  source   = "spacelift.io/incontact/pocredirector-dns-srv/default"
  version  = "1.1.0"

  # instance_name = "pocredirector" # Default
  pop_name = each.key
  domain   = local.domain

  primary        = each.value.primary.endpoint_fqdns
  primary_port   = each.value.primary.service_port
  secondary      = each.value.secondary == null ? [] : each.value.secondary.endpoint_fqdns
  secondary_port = each.value.secondary == null ? 5060 : each.value.secondary.service_port
  tertiary       = each.value.tertiary == null ? [] : each.value.tertiary.endpoint_fqdns
  tertiary_port  = each.value.tertiary == null ? 5060 : each.value.tertiary.service_port
}