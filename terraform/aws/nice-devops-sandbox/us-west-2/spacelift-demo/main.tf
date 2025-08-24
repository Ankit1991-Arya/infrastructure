###################################################
# Spacelift demo for S3 bucket
###################################################

# This code is adding Pull throgh cache rule in AWS ECR 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 5.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "spacelift-test1-s3" {
   bucket = "spacelift-demo-test-s3-terraform"
   acl = "private"  
}