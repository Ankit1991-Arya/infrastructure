variable "partition_name" {
  type    = string
  default = "sectools-ausov1-au2"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "sectools-ausov1-au2-ap-southeast-2-sectools01"
  description = "Name of logging bucket for account"
}