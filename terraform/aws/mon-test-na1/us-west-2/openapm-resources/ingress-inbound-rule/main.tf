terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = "us-west-2"
}

locals {
  existing_sg_group = "sg-0f0df3817a012394f"
}

resource "aws_security_group_rule" "allow_http1" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  description       = "Allow ingress from the public for grafana"
  security_group_id = local.existing_sg_group
  prefix_list_ids   = ["pl-0136669707a6c5896"]
}

resource "aws_security_group_rule" "allow_http2" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  description       = "Allow ingress from the public for grafana"
  security_group_id = local.existing_sg_group
  prefix_list_ids   = ["pl-05fb59da2b69f0704"]
}

resource "aws_security_group_rule" "allow_http3" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  description       = "Allow ingress from the public for grafana"
  security_group_id = local.existing_sg_group
  prefix_list_ids   = ["pl-0722155e785d5261d"]
}

resource "aws_security_group_rule" "allow_http4" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  description       = "Allow ingress from the public for grafana"
  security_group_id = local.existing_sg_group
  prefix_list_ids   = ["pl-0bbd57d47929028bb"]
}
