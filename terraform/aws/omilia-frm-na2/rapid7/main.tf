locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
    CreatedBy           = "https://github.com/inContact//omilia-terraform-modules//modules/rapid7"
  }
}

module "rapid7" {
  source = "github.com/inContact/omilia-terraform-modules.git//modules/rapid7?ref=rapid7-ami"
}
