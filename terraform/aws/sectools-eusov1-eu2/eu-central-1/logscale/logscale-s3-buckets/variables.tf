variable "partition_name" {
  type    = string
  default = "sectools-eusov1-eu2"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "sectools-eusov1-eu2-eu-central-1-sectools01"
  description = "Name of logging bucket for account"
}