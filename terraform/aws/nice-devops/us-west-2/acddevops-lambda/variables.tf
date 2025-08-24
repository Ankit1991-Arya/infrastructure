variable "bucket_name" {
  type        = string
  description = "Name of the s3 bucket"
  default     = "acddevops-lambda"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "acddevops-lambda"
  description = "(optional) describe your variable"
}