locals {
  EnvVar_secrets_list = toset([
    "domain-name",
    "core-network-core-subnet",
    "systems-domaincontroller-asg",
    "systems-domaincontroller-nsg",
    "chef-environment-name",
    "chef-server-name",
    "chef-validation-key",
    "chef-server-crt"
  ])
  Systems_secrets_list = toset([
    "ad-domain-joiner-username",
    "ad-domain-joiner-password"
  ])

  # Add default tags (that can be overridden by var.tags)
  tags = merge(
    data.azurerm_resource_group.domain-controllers.tags,
    {
      CreatedBy       = "Terraform"
      TerraformModule = "azure-domain-controllers"
      Cluster         = "Global"
      DeviceType      = "Systems Domain Controller"
    },
    var.tags
  )

  virtual_machines = {
    for vm in var.instance_list :
    vm => {
      site_id           = regex("^..(?P<site_id>[ab])-.*$", vm)["site_id"]
      availability_zone = regex("^..(?P<site_id>[ab])-.*$", vm)["site_id"] == "a" ? "1" : "2"
    }
  }
}