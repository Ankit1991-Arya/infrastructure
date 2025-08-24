locals {
  sectools_vpc_id          = "vpc-0d246739cef8c1535"
  sectools_private_subnets = ["subnet-01b51000c9c969f3a", "subnet-0ce77c1a1497364ce", "subnet-040cae1a1478a6556"]
  privatelink_allowed_principals = toset([
    "637423616941", #ic-ausov1-au2
  ])
}
