locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
  }

  ami_id = "ami-0e349af1e7b124f4f"
  vpc_id = "vpc-0207b6f1b84936372"
  vpc_subnets = [
    "subnet-033204414d70322c1",
    "subnet-038906aa3cd5cd439"
  ]

  spacelift_api_key_endpoint = "https://incontact.app.spacelift.io"
}

# tfsec:ignore:aws-iam-no-policy-wildcards
module "omilia" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2?ref=v2.5.0"

  configuration = <<-EOT
    export SPACELIFT_TOKEN="${var.spacelift_token}"
    export SPACELIFT_POOL_PRIVATE_KEY="${var.worker_pool_private_key}"
  EOT

  ami_id            = local.ami_id
  ec2_instance_type = "t3.large"
  security_groups   = [aws_security_group.private_sg.id]
  vpc_subnets       = local.vpc_subnets

  min_size                   = 0
  max_size                   = 1
  autoscaling_max_create     = 1
  autoscaling_max_terminate  = 1
  spacelift_api_key_endpoint = local.spacelift_api_key_endpoint
  worker_pool_id             = var.worker_pool_id
  spacelift_api_key_id       = var.spacelift_api_key_id
  spacelift_api_key_secret   = var.spacelift_api_key_secret
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "private_sg" {
  vpc_id = local.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "spacelift-workers-pool"
  }
}
