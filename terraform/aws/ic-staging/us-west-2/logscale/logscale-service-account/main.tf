terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.91.0"
    }
  }
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

resource "aws_guardduty_publishing_destination" "guardduty_publishing_destination" {
  count           = (var.guard_duty_enabled == true && var.guard_duty_s3_bucket_enabled == true) ? 1 : 0
  detector_id     = "1eb4d3ff17b5cf6f409b4adf575ae497"
  destination_arn = module.s3_guardduty_bucket[0].s3_bucket_arn
  kms_key_arn     = aws_kms_key.guardduty_s3_kms_key[0].arn

  depends_on = [
    module.s3_guardduty_bucket,
    aws_s3_bucket_policy.guardduty_bucket_policy,
    aws_kms_key.guardduty_s3_kms_key
  ]
}