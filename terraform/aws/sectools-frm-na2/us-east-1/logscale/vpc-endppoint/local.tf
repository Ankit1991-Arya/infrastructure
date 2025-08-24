locals {
  sectools_vpc_id          = "vpc-0e656720bd6c65fb3"
  sectools_private_subnets = ["subnet-05e5d04611066b081", "subnet-06377c9cbc6af676b", "subnet-06ced50c37d26beb6"]
  privatelink_allowed_principals = toset([
    "751344753113", #ic-compliance-prod
  ])
}
