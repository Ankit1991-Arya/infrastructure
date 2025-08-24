locals {
  tags = merge(merge({
    CreatedBy       = "Terraform"
    Repository      = "https://github.com/inContact/infrastructure-live"
    TerraformModule = "modules/aws-prometheus-db"
    }, var.custom_tags),
    {
      Product             = var.product
      ApplicationOwner    = var.application_owner != null ? var.application_owner : var.infrastructure_owner
      InfrastructureOwner = var.infrastructure_owner
  })
}
