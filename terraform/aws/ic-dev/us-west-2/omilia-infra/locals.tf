locals {
  common_tags = {
    Product             = "Omilia"
    Service             = "Omilia"
    ApplicationOwner    = "CNC"
    InfrastructureOwner = "CNC"
    Owner               = "CNC"
  }
  instance_name = "omilia-rds"
  credentials   = jsondecode(aws_secretsmanager_secret_version.omilia-db-user.secret_string)
}