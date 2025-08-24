terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3, < 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "eks" {
  source  = "spacelift.io/incontact/acddevops-terraform-modules-eks-cluster/default"
  version = ">= 0.0.4"

  account_name                                     = "nice-devops-sandbox"
  eks_cluster_name                                 = "shared_eks01"
  addons_coredns_version                           = "v1.9.3-eksbuild.10"
  addons_kube_proxy_version                        = "v1.25.16-eksbuild.1"
  addons_ebs_csi_driver_version                    = "v1.25.0-eksbuild.1"
  addons_vpc_cni_version                           = "v1.15.4-eksbuild.1"
  environment_availability_zones                   = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cluster_endpoint_public_access_whitelisted_cidrs = ["204.176.204.135/32", "204.176.204.136/32", "100.20.86.60/32", "44.233.241.98/32", "44.231.249.232/32", "52.40.118.246/32", "54.71.107.74/32"]
  cluster_version                                  = "1.26"
  cni_custom_networking_enabled                    = true
  create_argocd_fargate_profile                    = true # This should only be set to `true` in environments where ArgoCD is hosted.
  environment_instance                             = "01"
  environment_name                                 = "shared_eks"
  public_dns_records                               = []
  tags = {
    CreatedBy = "terraform",
    Module    = "terraform/nice-devops-sandbox/us-west-2/shared_eks/01/eks-cluster",
    Owner     = "pipelineinfraautomation",
    Product   = "kubernetes",
    Repo      = "https://github.com/inContact/acddevops-kubernetes"
  }
  use_alb                   = true
  use_alb_private           = true
  use_nlb_private           = true
  use_global_accelerator    = true
  use_s3_cluster_bucket     = true
  use_waf                   = true
  use_waf_without_alb       = false
  use_elb_service_principal = false
  waf_ip_whitelist          = ["34.235.77.69/32"]
  waf_managed_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      override_action = "none"
      priority        = 10
      rule_action_override = [
        {
          action_to_use = "count",
          name          = "CrossSiteScripting_BODY"
        },
        {
          action_to_use = "count",
          name          = "EC2MetaDataSSRF_BODY"
        },
        {
          action_to_use = "count",
          name          = "EC2MetaDataSSRF_QUERYARGUMENTS"
        },
        {
          action_to_use = "count",
          name          = "SizeRestrictions_BODY"
        }
      ]
      vendor_name = "AWS"
    },
    {
      name                 = "AWSManagedRulesAmazonIpReputationList",
      override_action      = "none"
      priority             = 20
      rule_action_override = []
      vendor_name          = "AWS"
    },
    {
      name                 = "AWSManagedRulesKnownBadInputsRuleSet",
      override_action      = "none"
      priority             = 30
      rule_action_override = []
      vendor_name          = "AWS"
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      override_action = "none"
      priority        = 40
      rule_action_override = [
        {
          action_to_use = "allow",
          name          = "SQLi_BODY"
        }
      ]
      vendor_name = "AWS"
    },
    {
      name                 = "AWSManagedRulesLinuxRuleSet",
      override_action      = "none"
      priority             = 50
      rule_action_override = []
      vendor_name          = "AWS"
    },
    {
      name                 = "AWSManagedRulesUnixRuleSet",
      override_action      = "none"
      priority             = 60
      rule_action_override = []
      vendor_name          = "AWS"
    }
  ]
  cross_site_scripting_body_excluded_hosts_regex        = "sonar.devops-sandbox.niceincontact.com"
  ec2_metadata_ssrf_body_excluded_hosts_regex           = "argocd.devops-sandbox.niceincontact.com"
  ec2_metadata_ssrf_queryarguments_excluded_hosts_regex = "argocd.devops-sandbox.niceincontact.com"
  size_restrictions_body_excluded_hosts_regex           = "(actions-runner-controller|argocd|sonar).devops-sandbox.niceincontact.com"
  sqli_body_excluded_hosts_regex                        = "sonar.devops-sandbox.niceincontact.com"
  use_s3_cluster_bucket_v4_attributes                   = false
  privatelink_aws_services = {
    rds_aws_service = {
      route53_record    = "",
      service_name      = "com.amazonaws.us-west-2.rds",
      vpc_endpoint_type = "Interface"
    }
  }
  privatelink_allowed_principals = ["arn:aws:iam::032474939542:root"]
}

output "eks_outputs" {
  value = module.eks.eks_outputs
}

