variable "partition_name" {
  type    = string
  default = "sectools-frm-na2"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "sectools-frm-na2-us-east-1-sectools01"
  description = "Name of logging bucket for account"
}