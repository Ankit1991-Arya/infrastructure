terraform {
  required_version = ">= 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0,< 6.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Owner               = "MediaServices"
      Product             = "ACD"
      Service             = "MediaResourceManager"
      ApplicationOwner    = "MediaServices"
      InfrastructureOwner = "MediaServices"
    }
  }
}

module "media-resource-manager-mrm-elasticache" {
  source  = "spacelift.io/incontact/media-resource-manager-mrm-elasticache/default"
  version = "0.0.14"

  # Required inputs
  aws_elasticache_subnet_group_name = "mrm-elasticache-subnet-group"
  elasticache_cluster_name          = "mrm-elasticache"
  elasticache_cluster_user_group_id = "mrm-elasticache-user-group"
  elasticache_cluster_user_id       = "mrm-elasticache-user"
  logs_retations_days               = 7
  node_type                         = "cache.m6g.xlarge"
  number_shards                     = 2
  read_replica_per_shards           = 1
  email_subscription = {
    email1 = "tarvez.khan@nice.com"
    email2 = "sagar.mali3@nice.com"
    email3 = "sameer.joshi@nice.com"
    email4 = "divya.gorsawala@nice.com"
    email5 = "saroj.patra@nice.com"
    email6 = "mugdha.kulkarni@nice.com"
    email7 = "sudarshan.kannan@nice.com"
    email8 = "nayan.modhave@nice.com"
    email9 = "neha.jagtap@nice.com"
  }

  subnet_cloudformation_export_names_for_VC_Servers = [
    "CoreNetwork-Az1CoreSubnet",
    "CoreNetwork-Az2CoreSubnet"
  ]

  # Optional inputs
  # automatic_failover                                = bool
  # engine_version                                    = string
  # maintenance_window                                = string
  # mrm_parameter_group                               = string
  # parameter_group                                   = string
  # sns_topic-name                                    = string
  # subnet_cloudformation_export_names_for_VC_Servers = list(string)

}

module "media-resource-manager-mrm-elasticache-alerts" {
  source  = "spacelift.io/incontact/media-resource-manager-mrm-elasticache-alerts/default"
  version = "0.0.5"

  # Optional inputs, you can set the thresholds for the following metrics for testing purposes only

  # cpu_threshold_critical                        = 3.6
  # cpu_threshold_major                           = 3.45
  # current_connections_threshold_critical        = 62000
  # current_connections_threshold_major           = 60000
  # engine_cpu_threshold_critical                 = 0.6
  # engine_cpu_threshold_major                    = 0.55
  # freeable_memory_threshold_critical            = 15710000000
  # freeable_memory_threshold_major               = 15720000000
  # memory_threshold_critical                     = 0.2874
  # memory_threshold_major                        = 0.2872
  set_based_commands_latency_threshold_critical = 100
  set_type_commands_latency_threshold_critical  = 100
}

