locals {
  sectools_vpc_id          = "vpc-04af41a12c4911516"
  sectools_private_subnets = ["subnet-0994c3ec29a33fb9a", "subnet-0a59644632951783a", "subnet-0fa3f33fbd6f82ab9"]
  privatelink_allowed_principals = toset([
    "533267422300", #ic-eusov1-eu2
  ])
}
