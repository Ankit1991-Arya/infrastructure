terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

locals {
  config_data = yamldecode(file("./inputs.yaml"))
}

module "vpc-us-west-2" {
  source = "./modules/vpc"
  providers = {
    aws = aws.oregon
  }
  vpc_config                = local.config_data
  network_load_balancer_arn = module.nlb-us-west-2.nlb_arn_output
  subnet_id                 = module.subnet-us-west-2.subnet_id_output
}

module "subnet-us-west-2" {
  source = "./modules/subnet"
  providers = {
    aws = aws.oregon
  }
  subnet_config = local.config_data
  vpc_id        = module.vpc-us-west-2.vpc_id_output
}

module "nlb-us-west-2" {
  source = "./modules/nlb"
  providers = {
    aws = aws.oregon
  }
  nlb_config = local.config_data
  subnets_id = module.subnet-us-west-2.subnet_id_output
  vpc_id     = module.vpc-us-west-2.vpc_id_output
}