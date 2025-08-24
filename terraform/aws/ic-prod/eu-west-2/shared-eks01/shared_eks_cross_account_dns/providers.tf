terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Owner               = "CloudNativeCore"
      Product             = "Infrastructure"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
      Service             = "SharedEKS"
      ApplicationOwner    = "devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner = "devops-cloud-native-core@NiceinContact.com"
    }
  }
}