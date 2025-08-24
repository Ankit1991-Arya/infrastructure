terraform {
  required_version = ">= 1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# TODO: Turn the stuff past this point into a terraform module for use in other environments (if the POC is successful)

locals {
  name = "github-actions-windows"
  tags = {
    Name                = local.name
    Owner               = "CloudNativeCore"
    InfrastructureOwner = "CloudNativeCore"
    ApplicationOwner    = "CloudNativeCore"
    Product             = "Infrastructure"
    Service             = "Github Actions"
    Repo                = "https://github.com/inContact/infrastructure-live"
  }

  vpc_name = "Dev-core-network"
  subnet_names = ["Az1 Core Subnet", "Az2 Core Subnet"]
  iam_role = "ServiceAccess-acddevops-gha-ecs-windows"
}

# Configuration based on example from https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/master/examples/ec2-autoscaling/main.tf
module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"
  version = "~> 5.11"

  cluster_name = local.name

  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {
    # Spot instances
    spot = {
      auto_scaling_group_arn = module.autoscaling["spot"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 10
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 90
      }

      default_capacity_provider_strategy = {
        weight = 40
      }
    }
  }

  tags = local.tags
}

data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-ECS_Optimized"
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "selected" {
  filter {
    name = "tag:Name"
    values = local.subnet_names
  }
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_iam_instance_profile" "selected" {
  name = local.iam_role
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  for_each = {
    # # On-demand instances
    # ondemand = {
    #   instance_type              = "t3.large"
    #   use_mixed_instances_policy = false
    #   mixed_instances_policy     = {}
    #   user_data                  = <<-EOT
    #     #!/bin/bash

    #     cat <<'EOF' >> /etc/ecs/ecs.config
    #     ECS_CLUSTER=${local.name}
    #     ECS_LOGLEVEL=debug
    #     ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.tags)}
    #     ECS_ENABLE_TASK_IAM_ROLE=true
    #     EOF
    #   EOT
    # }
    # Spot instances
    spot = {
      instance_type              = "t3.xlarge"
      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 0
          spot_allocation_strategy                 = "price-capacity-optimized"
        }

        override = [
          {
            instance_type     = "t3.2xlarge"
            weighted_capacity = "2"
          },
          {
            instance_type     = "t2.xlarge"
            weighted_capacity = "1"
          },
        ]
      }
      user_data = <<-EOT
        <powershell>
        Import-Module ECSTools
        [Environment]::SetEnvironmentVariable("ECS_CLUSTER", "${local.name}", "Machine")
        [Environment]::SetEnvironmentVariable("ECS_IMAGE_PULL_BEHAVIOR", "once", "Machine")
        [Environment]::SetEnvironmentVariable("ECS_AWSVPC_BLOCK_IMDS", "true", "Machine")
        [Environment]::SetEnvironmentVariable("ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE", "true", "Machine")
        [Environment]::SetEnvironmentVariable("ECS_ENABLE_TASK_CPU_MEM_LIMIT","true","Machine")
        [Environment]::SetEnvironmentVariable("ECS_CONTAINER_INSTANCE_TAGS", '${jsonencode(local.tags)}', "Machine")
        [Environment]::SetEnvironmentVariable("ECS_ENABLE_SPOT_INSTANCE_DRAINING", $TRUE, "Machine")
        # Initialize-ECSAgent -EnableTaskENI -LoggingDrivers "['json-file','awslogs']"
        Initialize-ECSAgent -EnableTaskIAMRole -EnableTaskENI -LoggingDrivers "['json-file','awslogs']"
        </powershell>
      EOT
    }
  }

  name = "${local.name}-${each.key}"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = each.value.instance_type

  security_groups                 = [module.autoscaling_sg.security_group_id]
  user_data                       = base64encode(each.value.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = false
  iam_instance_profile_arn    = data.aws_iam_instance_profile.selected.arn
  iam_instance_profile_name   = data.aws_iam_instance_profile.selected.name
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 2
  }

  vpc_zone_identifier = data.aws_subnets.selected.ids
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 10
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = true

  # Spot instances
  use_mixed_instances_policy = each.value.use_mixed_instances_policy
  mixed_instances_policy     = each.value.mixed_instances_policy

  tags = local.tags
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Autoscaling group security group"
  vpc_id      = data.aws_vpc.selected.id

  egress_rules = ["all-all"]

  tags = local.tags
}
