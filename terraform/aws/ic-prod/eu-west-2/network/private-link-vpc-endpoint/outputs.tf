output "security_group_ids" {
  value = {
    for k, sg in module.security_groups : k => sg.security_group_id
  }
}

output "vpc_endpoint_ids" {
  value = {
    for k, vpce in module.vpc_endpoints : k => vpce.vpc_endpoint_id
  }
}