# These modules create a NAPTR and SRV for each POP where SBCs are found
# Adding a new pop is as simple as adding a new mapping to the locals section below
locals {
  pops = {
    # Los Angeles, US
    lax = {
      primary   = module.pocredirector_na1
      secondary = module.pocredirector_ca1
      tertiary  = module.pocredirector_uk1
    }
    # Dallas, US
    dal = {
      primary   = module.pocredirector_na1
      secondary = module.pocredirector_ca1
      tertiary  = module.pocredirector_uk1
    }
    # Sao Paulo, Brazil
    sp4 = {
      primary   = module.pocredirector_na1
      secondary = module.pocredirector_ca1
      tertiary  = module.pocredirector_uk1
    }
    # Rio, Brazil
    rj2 = {
      primary   = module.pocredirector_na1
      secondary = module.pocredirector_ca1
      tertiary  = module.pocredirector_uk1
    }
    # Toronto, Canada
    tr2 = {
      primary   = module.pocredirector_ca1
      secondary = module.pocredirector_na1
      tertiary  = module.pocredirector_uk1
    }
    # Montreal, Canada
    mtl7 = {
      primary   = module.pocredirector_ca1
      secondary = module.pocredirector_na1
      tertiary  = module.pocredirector_uk1
    }
    # Manchester, UK
    ma4 = {
      primary   = module.pocredirector_uk1
      secondary = module.pocredirector_eu1
      tertiary  = module.pocredirector_ca1
    }
    # London, UK
    ld7 = {
      primary   = module.pocredirector_uk1
      secondary = module.pocredirector_eu1
      tertiary  = module.pocredirector_ca1
    }
    # Frankfurt, Germany
    fr4 = {
      primary   = module.pocredirector_eu1
      secondary = module.pocredirector_uk1
      tertiary  = module.pocredirector_ca1
    }
    # Munich, Germany
    mu1 = {
      primary   = module.pocredirector_eu1
      secondary = module.pocredirector_uk1
      tertiary  = module.pocredirector_ca1
    }
    # Abu Dhabi, UAE
    ad2 = {
      primary   = module.pocredirector_eu1
      secondary = module.pocredirector_uk1
      tertiary  = module.pocredirector_jp1
    }
    # Dubai, UAE
    db2 = {
      primary   = module.pocredirector_eu1
      secondary = module.pocredirector_uk1
      tertiary  = module.pocredirector_jp1
    }
    # Tokyo, Japan
    ty6 = {
      primary   = module.pocredirector_jp1
      secondary = module.pocredirector_au1
      tertiary  = module.pocredirector_eu1
    }
    # Osaka, Japan
    os1 = {
      primary   = module.pocredirector_jp1
      secondary = module.pocredirector_au1
      tertiary  = module.pocredirector_eu1
    }
    # Singapore, Singapore
    sg2 = {
      primary   = module.pocredirector_jp1
      secondary = module.pocredirector_au1
      tertiary  = module.pocredirector_eu1
    }
    # Sydney, Australia
    sy1 = {
      primary   = module.pocredirector_au1
      secondary = module.pocredirector_jp1
      tertiary  = module.pocredirector_eu1
    }
    # Melbourne, Australia
    me1 = {
      primary   = module.pocredirector_au1
      secondary = module.pocredirector_jp1
      tertiary  = module.pocredirector_eu1
    }
    # Mumbai, India
    mb1 = {
      primary   = module.pocredirector_jp1
      secondary = module.pocredirector_eu1
      tertiary  = module.pocredirector_au1
    }
    # Hydrabad, India
    hy1 = {
      primary   = module.pocredirector_jp1
      secondary = module.pocredirector_eu1
      tertiary  = module.pocredirector_au1
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
