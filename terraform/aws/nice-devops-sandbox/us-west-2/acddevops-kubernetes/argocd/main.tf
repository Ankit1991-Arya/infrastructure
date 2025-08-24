terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
    external = "2.0.0"
    helm     = "2.7.1"
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    tls = "3.0.0"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster" "this" {
  name = "shared_eks01"
}

data "aws_eks_cluster_auth" "this" {
  name = "shared_eks01"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

module "argocd_install_sandbox" {
  source  = "spacelift.io/incontact/acddevops-terraform-modules-eks-argocd/default"
  version = ">= 0.0.2"

  providers = {
    aws.external       = aws
    kubernetes.argocd  = kubernetes
    helm.external_helm = helm
  }

  ARGOCD_DEX_APP_CLIENT_ID                                       = "f14a9748239138d64fa1"
  ARGOCD_DEX_CLIENT_SECRET                                       = var.ARGOCD_DEX_CLIENT_SECRET
  ARGOCD_GITHUB_APP_PRIVATE_KEY                                  = var.ARGOCD_GITHUB_APP_PRIVATE_KEY
  ARGOCD_GITHUB_WEBHOOK_SECRET                                   = var.ARGOCD_GITHUB_WEBHOOK_SECRET
  ARGOCD_NOTIFICATIONS_GITHUB_APP_PRIVATE_KEY                    = var.ARGOCD_NOTIFICATIONS_GITHUB_APP_PRIVATE_KEY
  MSTEAMS_WEBHOOK_NICE_INCONTACT_KUBERNETES_ARGOCD_NOTIFICATIONS = var.MSTEAMS_WEBHOOK_NICE_INCONTACT_KUBERNETES_ARGOCD_NOTIFICATIONS
  PAT_NICECXONE_ARGOCD_NOTIFICATIONS_GITHUB_USER                 = var.PAT_NICECXONE_ARGOCD_NOTIFICATIONS_GITHUB_USER
  account_name                                                   = "nice-devops-sandbox"
  alb_logs_bucket                                                = "nice-devops-sandbox-us-west-2-sharedeks01"
  appset_generator_path                                          = "releases/ndso/*/*/*/argocd.yaml"
  argo_helm_version                                              = "5.36.0"
  argocd_annotations = {
    "nice.com/owner" : "devops-cloud-native-core@niceincontact.com"
    "nice.com/product" : "argocd"
  }
  argocd_controller_replicas = "5"
  argocd_hostname            = "argocd.devops-sandbox.niceincontact.com"
  argocd_image_uri           = "032474939542.dkr.ecr.us-west-2.amazonaws.com/incontact/acddevops-kubernetes/argocd"
  aws_waf_name               = "shared_eks01-us-west-2"
  controller_resources = {
    # limits and requests should be the same since these pods are running on fargate
    # size should be chosen from the list of available values in the table on this page: https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html#fargate-cpu-and-memory
    limits = {
      cpu    = "1"
      memory = "2G"
    }
    requests = {
      cpu    = "1"
      memory = "2G"
    }
  }
  dex_image_uri    = "032474939542.dkr.ecr.us-west-2.amazonaws.com/acddevops-kubernetes-workloads/dexidp/dex"
  ecr_repo         = "032474939542.dkr.ecr.us-west-2.amazonaws.com/acddevops-kubernetes-charts"
  eks_cluster_name = "shared_eks01"
  kubernetes_labels = {
    CreatedBy = "terraform"
    Module    = "terraform.nice-devops-sandbox.us-west-2.shared_eks.01.argo"
    Owner     = "pipelineinfraautomation"
    Product   = "kubernetes"
    Repo      = "https.github.com.inContact.acddevops-kubernetes"
  }

  redis_image_uri = "032474939542.dkr.ecr.us-west-2.amazonaws.com/acddevops-kubernetes-workloads/redis"
  redis_resources = {
    # limits and requests should be the same since these pods are running on fargate
    # Size should be chosen from the list of available values in the table on this page: https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html#fargate-cpu-and-memory
    limits = {
      cpu    = "500m"
      memory = "1G"
    }
    requests = {
      cpu    = "500m"
      memory = "1G"
    }
  }
  region_name = "us-west-2"
  repoServer_autoscaling = {
    minReplicas = "3"
    maxReplicas = "6"
    enabled     = true
  }
  repoServer_resources = {
    # limits and requests should be the same since these pods are running on fargate
    # Size should be chosen from the list of available values in the table on this page: https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html#fargate-cpu-and-memory
    # Memory limit must be large enough to pull down kubernetes manifest repositories
    limits = {
      cpu    = "1"
      memory = "2G"
    }
    requests = {
      cpu    = "1"
      memory = "2G"
    }
  }
  server_autoscaling = {
    minReplicas = "3"
    maxReplicas = "6"
    enabled     = true
  }
  server_resources = {
    # limits and requests should be the same since these pods are running on fargate
    # Size should be chosen from the list of available values in the table on this page: https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html#fargate-cpu-and-memory
    limits = {
      cpu    = "1"
      memory = "2G"
    }
    requests = {
      cpu    = "1"
      memory = "2G"
    }
  }
}
