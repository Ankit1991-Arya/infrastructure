variable "partition_name" {
  type    = string
  default = "sectools-frm-na2-us-east-1"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "sectools-frm-na2-us-east-1-s3-bucket-logs"
  description = "Name of s3 bucket for logging"
}