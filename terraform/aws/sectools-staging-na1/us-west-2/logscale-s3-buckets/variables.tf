variable "partition_name" {
  type    = string
  default = "sectools-na1"
}

variable "logs_s3_bucket_id" {
  type        = string
  default     = "sectools-staging-na1-us-west-2-crowdstrike01"
  description = "(optional) describe your variable"
}