locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
  }
}

module "vpc" {
  source = "github.com/inContact/omilia-aws-eks-network.git//modules/vpc?ref=v1.0.1"

  # VPC Vars
  name                              = "omilia"
  enable_flow_logs                  = true
  log_destination_type              = "cloud-watch-logs"
  vpc_cidr                          = "10.200.0.0/16"
  public_subnets                    = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
  map_public_ip_on_launch           = false
  private_subnets                   = ["10.200.128.0/19", "10.200.160.0/19", "10.200.192.0/19"]
  database_subnets                  = ["10.200.6.0/24", "10.200.7.0/24", "10.200.8.0/24"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true

  tags = merge(local.standard_tags, {
    Environment = "prod"
    CreatedBy   = "https://github.com/inContact//omilia-aws-eks-network//modules/vpc"
    #"kubernetes.io/cluster/ocp-prod-iamvITXK" = "shared"
  })

  #public_subnet_tags = {
  #  "kubernetes.io/cluster/ocp-stage-dMejukzg" = "shared"
  #  "kubernetes.io/role/elb"                   = "1"
  #}
  #private_subnet_tags = {
  #  "kubernetes.io/cluster/ocp-stage-dMejukzg" = "shared"
  #  "kubernetes.io/role/internal-elb"          = "1"
  #}
}