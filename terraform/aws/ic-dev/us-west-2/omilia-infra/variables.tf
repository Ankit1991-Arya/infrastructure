
variable "environment" {
  type        = string
  description = "A value distinguishing the various environments."
  default     = "do"
}

variable "engine_version" {
  type        = string
  description = "Aurora mysql aurora version."
  default     = "8.0.mysql_aurora.3.03.0"
}
variable "database_name" {
  type        = string
  description = "Auroradb database name"
  default     = "omilia"
}

variable "username" {
  type        = string
  description = "Username to connect to auroradb"
  default     = "masteruser"
}

variable "region" {
  default     = "us-west-2"
  description = "AWS region for the deployment"
  type        = string
}

variable "vpc_name_common" {
  type        = string
  description = "VPC used for RDS"
  default     = "OmiliaPOC-VPC" # in ic-dev
}

variable "db_subnet_group_common" {
  type        = string
  description = "DB Subnet Group used in RDS"
  default     = "omilia-rds-subnetgroup" # in ic-dev
}

variable "vpc_cidr" {
  description = "CIDR range of EKS pods."
  type        = string
  default     = "10.0.0.0/16"
}

variable "min_acu" {
  description = "Minimum ACU for RDS."
  type        = number
  default     = 2
}

variable "max_acu" {
  description = "Maximum ACU for RDS."
  type        = number
  default     = 10
}

variable "instance_count" {
  description = "Instance count."
  type        = number
  default     = 3
}