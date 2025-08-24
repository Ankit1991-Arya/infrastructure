terraform {
  required_version = ">= 1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Product             = "MSK"
      Repository          = "https://github.com/inContact/infrastructure-live"
      InfrastructureOwner = "devops-cloud-native-core@niceincontact.com"
      ApplicationOwner    = "ESC / esc@niceincontact.com"
    }
  }
}

# The module below if uncommented and pushed to main will create a MSK cluster that can be used by our ESC microservices
# First deploy the module with public access as false and then update the module with public access as true

#module "cluster" {
#  source  = "spacelift.io/incontact/msk-cluster/default"
#  version = "0.1.10"
#  vpc-id  = "vpc-05f9227c"
#  subnets = ["subnet-05aa0bbab2507708e",
#    "subnet-054b396bb5504cd92",
#  "subnet-0eaf3e32fbed826c5 "]
#
#  name-prefix = "shared-msk02"
#  name        = "esc-dev"
#  region      = "us-west-2"
#  allowed-cidrs = [
#    { "cidr" : "35.163.192.192/32", "description" : "ic-dev shared_eks_us-west-2a NAT Gateway" },
#    { "cidr" : "44.240.41.173/32", "description" : "ic-dev shared_eks_us-west-2b NAT Gateway" },
#    { "cidr" : "54.68.170.194/32", "description" : "ic-dev shared_eks_us-west-2c NAT Gateway" },
#    { "cidr" : "54.71.143.211/32", "description" : "ic-dev Dev-Core-Network AZ 1 NAT Gateway" },
#    { "cidr" : "52.40.220.163/32", "description" : "ic-dev Dev-Core-Network AZ 2 NAT Gateway" },
#    { "cidr" : "54.214.205.249/32", "description" : "nice-devops-sandbox CICD-WFO.Tools NAT Gateway A" },
#    { "cidr" : "54.71.107.74/32", "description" : "nice-devops-sandbox CICD-WFO.Tools NAT Gateway B" },
#    { "cidr" : "54.189.111.43/32", "description" : "nice-devops-sandbox CICD-WFO.Tools NAT Gateway C" },
#    { "cidr" : "54.149.7.150/32", "description" : "nice-devops-sandbox CICD-WFO.Tools NAT Gateway D" },
#    { "cidr" : "100.20.86.60/32", "description" : "NGW for nice-devops us-west-2 shared_eks VPC (kbastion)" },
#    { "cidr" : "44.233.241.98/32", "description" : "NGW for nice-devops us-west-2 shared_eks VPC (kbastion)" },
#    { "cidr" : "44.231.249.232/32", "description" : "NGW for nice-devops us-west-2 shared_eks VPC (kbastion)" },
#    { "cidr" : "52.40.144.103/32", "description" : "cea-it-mgmt NAT Gateway us-west-2a" },
#    { "cidr" : "44.224.94.163/32", "description" : "cea-it-mgmt NAT Gateway us-west-2b" }
#  ]
#  kafka-version                             = "3.5.1"
#  number-of-broker-nodes-per-az             = 1
#  replication-factor                        = 3
#  instance-type                             = "kafka.m5.large"
#  encryption-type                           = "TLS"
#  ebs-volume-size                           = 1000
#  public-access                             = false
#  delete-enabled                            = true
#  storage-autoscaling-enabled               = false
#  max-volume-size                           = 1050
#  storage-utilization                       = 60
#  broker-logs-enabled                       = true
#  enhanced-monitoring-level                 = "PER_TOPIC_PER_PARTITION"
#  sasl-iam-auth-enabled                     = true
#  sasl-scram-auth-enabled                   = true
#  auto-create-topics-enabled                = false
#  ec2-allowed-cidrs-ingress-max-rules-count = 15
#  msk-alarm-topic-name                      = "esc_dev_msk_alarm_topic"
#  msk-alarm-topic-non-prod                  = "esc_dev_msk_alarm_topic_non_prod"
#}