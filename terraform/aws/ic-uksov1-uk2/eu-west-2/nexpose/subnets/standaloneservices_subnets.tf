#Adding subnets for StandaloneServices VPC
data "aws_region" "current" {}

data "aws_cloudformation_export" "standaloneservices_vpc_id" {
  name = "StandaloneServices-Vpc"
}

data "aws_vpc" "standaloneservices_vpc" {
  id = data.aws_cloudformation_export.standaloneservices_vpc_id.value
}

resource "aws_subnet" "az1_private_nexpose" {
  vpc_id            = data.aws_vpc.standaloneservices_vpc.id
  cidr_block        = "10.0.37.0/27"
  availability_zone = "${data.aws_region.current.name}a"
  tags = {
    Name = "Az1 Private Nexpose"
  }
}

resource "aws_subnet" "az2_private_nexpose" {
  vpc_id            = data.aws_vpc.standaloneservices_vpc.id
  cidr_block        = "10.0.37.32/27"
  availability_zone = "${data.aws_region.current.name}b"
  tags = {
    Name = "Az2 Private Nexpose"
  }
}

resource "aws_subnet" "az3_private_nexpose" {
  vpc_id            = data.aws_vpc.standaloneservices_vpc.id
  cidr_block        = "10.0.37.64/27"
  availability_zone = "${data.aws_region.current.name}c"
  tags = {
    Name = "Az3 Private Nexpose"
  }
}

resource "aws_route_table" "nexpose_route_table" {
  vpc_id = data.aws_vpc.standaloneservices_vpc.id

  route {
    cidr_block = data.aws_vpc.standaloneservices_vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = local.nat_gateway
  }
}

resource "aws_route_table_association" "az1_subnet" {
  subnet_id      = aws_subnet.az1_private_nexpose.id
  route_table_id = aws_route_table.nexpose_route_table.id
}

resource "aws_route_table_association" "az2_subnet" {
  subnet_id      = aws_subnet.az2_private_nexpose.id
  route_table_id = aws_route_table.nexpose_route_table.id
}

resource "aws_route_table_association" "az3_subnet" {
  subnet_id      = aws_subnet.az3_private_nexpose.id
  route_table_id = aws_route_table.nexpose_route_table.id
}