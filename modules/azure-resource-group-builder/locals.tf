locals {
  EnvVar_secrets_list = toset([
    "cxone-system-id",
    "cxone-area-id"
  ])
  common_tags = {
    CreatedBy       = "Terraform"
    TerraformModule = "azure-resource-group-builder"
  }

  role_assignments = flatten([
    for repository_name, repository_value in var.repository_role_assignment : [
      for resource_group_name, resource_group_value in repository_value : [
        for role in resource_group_value : {
          repository_name = repository_name
          group_name      = resource_group_name
          role_name       = role
        }
      ]
    ]
  ])

  subscription_id = {
    AZU-IC-COGS-CXONE-PROD   = "bfd801d5-9e25-47c9-93e4-d329d8d61246"
    AZU-IC-RND-CXONE-STAGING = "e7177268-61d6-4915-b28c-79acba57046b"
    AZU-IC-RND-CXONE-TEST    = "56a46408-b4a2-45df-aef5-92cddf4ef946"
    ic-prod-azu              = "1f447cac-a9a2-4980-8990-a6e957f5903"
    ic-tools-azu             = "bc7b0f7b-4fec-461d-8f71-77af69b7565a"
  }
}