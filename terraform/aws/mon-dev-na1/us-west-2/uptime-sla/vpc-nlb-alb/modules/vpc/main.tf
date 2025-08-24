
resource "aws_vpc" "uptime-vpc" {
  cidr_block =  var.vpc_config.data.vpc.cidr
  tags = { Name = "Uptime-Service-VPC" }
}

resource "aws_route_table" "uptime-rt" {
  vpc_id = aws_vpc.uptime-vpc.id
}

resource "aws_route_table_association" "uptime-rt-assoc" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.uptime-rt.id
}

# resource "aws_vpc_endpoint_service" "uptime-service-advanced" {
#   network_load_balancer_arns = [var.network_load_balancer_arn]
#   acceptance_required        = true
#   allowed_principals         = var.vpc_config.data.vpc.allowed_principals
# }

resource "aws_flow_log" "vpc-flow-log" {
  vpc_id = aws_vpc.uptime-vpc.id
  traffic_type = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination = var.vpc_config.data.vpc.log_group_arn
  iam_role_arn = var.vpc_config.data.role.arn
}

output "vpc_id_output" {
  value       = aws_vpc.uptime-vpc.id
}
