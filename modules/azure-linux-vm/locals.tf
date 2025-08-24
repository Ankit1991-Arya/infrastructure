locals {
  # We can potentially use locals to transform resource name to meet computer name requirements
  composed_vm_computer_name = var.virtual_machine_computer_name

  virtual_machine_identity_type = (length(var.user_assigned_identity_ids) > 0 ?
    var.system_assigned_identity ? "SystemAssigned, UserAssigned" : "UserAssigned"
    : var.system_assigned_identity ? "SystemAssigned" : ""
  )

  tags = merge(
    {
      CreatedBy = "Terraform"
    },
    var.tags
  )

  # Eliminate potential duplicate "https://" from chef_server_url variable
  chef_server_url = "https://${replace("${var.chef_server_url}", "/(http|https):///", "")}"

  chef_bootstrap_extension_settings = jsonencode({
    "bootstrap_options" = {
      "chef_node_name"         = "${azurerm_linux_virtual_machine.this.computer_name}"
      "chef_server_url"        = "${local.chef_server_url}"
      "environment"            = "${var.chef_environment}"
      "validation_client_name" = "incontact-validator"
    }
    "chef_daemon_interval"  = "0"
    "runlist"               = "${var.chef_runlist}"
    "validation_key_format" = "base64encoded"
  })

  chef_bootstrap_extension_protected_settings = <<-EOF
  {
    "validation_key": "${var.chef_validation_key}",
    "chef_server_crt": "${var.chef_server_crt}"
  }
  EOF
}
