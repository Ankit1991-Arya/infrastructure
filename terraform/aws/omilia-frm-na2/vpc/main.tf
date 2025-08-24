module "vpc" {
  source = "github.com/inContact/omilia-aws-eks-network.git//modules/vpc?ref=v1.0.1"

  # VPC Vars
  name                              = "omilia"
  enable_flow_logs                  = true
  log_destination_type              = "cloud-watch-logs"
  vpc_cidr                          = "10.200.0.0/16"
  public_subnets                    = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
  map_public_ip_on_launch           = false
  private_subnets                   = ["10.200.3.0/24", "10.200.4.0/24", "10.200.5.0/24"]
  database_subnets                  = ["10.200.6.0/24", "10.200.7.0/24", "10.200.8.0/24"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true

  tags = local.tags

  public_subnet_tags = {
    "kubernetes.io/cluster/ocp-prod-iamvITXK" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/ocp-prod-iamvITXK" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

locals {
  tags = {
    Environment                               = "fedramp"
    CreatedBy                                 = "https://github.com/inContact//omilia-aws-eks-network//modules/vpc"
    ApplicationOwner                          = "systemengineering@nice.com"
    InfrastructureOwner                       = "systemengineering@nice.com"
    Product                                   = "Omilia"
    "kubernetes.io/cluster/ocp-prod-iamvITXK" = "shared"
  }
}
