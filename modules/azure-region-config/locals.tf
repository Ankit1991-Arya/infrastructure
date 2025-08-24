locals {
  common_tags = {
    ApplicationOwner    = "Systems Teams"
    InfrastructureOwner = "Systems Teams"
    Product             = "Infrastructure"
    CreatedBy           = "Terraform"
    TerraformModule     = "azure-region-config"
  }
  environment_variables = {
    chef-environment-name                 = var.chef-environment-name
    chef-server-name                      = var.chef-server-name
    deployment-files-bucket               = var.deployment-files-bucket
    domain-name                           = var.domain-name
    ad-base-ou-name                       = var.ad-base-ou-name
    ad-base-ou-distinguished-name         = "OU=${var.ad-base-ou-name},DC=${split(".", var.domain-name)[0]},DC=${split(".", var.domain-name)[1]}"
    external-domain-name                  = var.external-domain-name
    external-domain-name-for-new-services = var.external-domain-name-for-new-services
    ic-region-id                          = var.ic-region-id
    site-a                                = "${var.ic-region-id}a"
    site-b                                = "${var.ic-region-id}b"
    # SSLCertThumbprint                     = data.azurerm_key_vault_certificate.SSLCert.thumbprint
  }
}