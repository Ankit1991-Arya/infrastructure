locals {
  backend_address_pool_nic_associations = merge([
    for backend_pool, instances in var.backend_address_pool_map : {
      for instance_key, instance in instances : "${backend_pool}_${instance_key}" => {
        network_interface_id    = instance.network_interface_id
        ip_configuration_name   = instance.ip_configuration_name
        backend_address_pool_id = azurerm_lb_backend_address_pool.this[backend_pool].id
      }
    }
  ]...)
}