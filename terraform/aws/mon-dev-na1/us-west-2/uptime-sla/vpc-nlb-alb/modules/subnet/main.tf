resource "aws_subnet" "uptime-subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_config.data.subnet.cidr
  availability_zone = var.subnet_config.data.subnet.availability_zone
  tags              = { Name = "Uptime-Service-Subnet" }
}

output "subnet_id_output" {
  value       = aws_subnet.uptime-subnet.id
}