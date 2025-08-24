terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      ApplicationOwner    = "DFOReportingPune / CXOne_Digital_Data_Reporting_Pune@nice.com"
      InfrastructureOwner = "DFOReportingPune / CXOne_Digital_Data_Reporting_Pune@nice.com"
      Product             = "entitymanagement"
      Service             = "dfo State Streams"
      Repo                = "https://github.com/inContact/infrastructure-live.git"
    }
  }
}
