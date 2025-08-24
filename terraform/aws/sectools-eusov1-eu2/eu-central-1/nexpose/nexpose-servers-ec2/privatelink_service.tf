resource "aws_vpc_endpoint_service" "nexpose_endpoint_service" {
  acceptance_required        = false
  network_load_balancer_arns = concat([aws_lb.nexpose_private_nlb.arn])
  private_dns_name           = local.nexpose_private_domain_name
  tags = {
    Name = "Nexpose-Security-Console"
  }
}

resource "aws_vpc_endpoint_service_allowed_principal" "principal" {
  for_each                = local.privatelink_allowed_principals
  principal_arn           = "arn:aws:iam::${each.key}:root"
  vpc_endpoint_service_id = aws_vpc_endpoint_service.nexpose_endpoint_service.id
}
