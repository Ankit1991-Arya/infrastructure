terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, <= 5.74.0"
    }
  }
  required_version = ">= 1.0"
}
provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Owner               = "Systems Engineering"
      Product             = "System"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "Logscale"
      InfrastructureOwner = "Systems Engineering"
      ApplicationOwner    = "Systems Engineering"
    }
  }
}

locals {
  infra_hosted_zone = "infra.ausov1.internal"
  vpc_endpoint_DNS  = "vpce-0536e9961c6e244ac-7z5vuqk5.vpce-svc-01c6e3570e60d8c46.ap-southeast-2.vpce.amazonaws.com"
}

data "aws_route53_zone" "infra" {
  name         = "${local.infra_hosted_zone}."
  private_zone = true
}

resource "aws_route53_record" "logscale_cname_record" {
  zone_id = data.aws_route53_zone.infra.id
  name    = "logscale.${data.aws_route53_zone.infra.name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.vpc_endpoint_DNS]
}

resource "aws_route53_record" "logscale_ingest_cname_record" {
  zone_id = data.aws_route53_zone.infra.id
  name    = "logscale-ingest.${data.aws_route53_zone.infra.name}"
  type    = "CNAME"
  ttl     = 300
  records = [local.vpc_endpoint_DNS]
}