variable "oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::127214159914:oidc-provider/oidc.eks.ap-southeast-2.amazonaws.com/id/70BAB49A38B3261E8854C8C006363438"
}

variable "namespace" {
  type    = string
  default = "logscale"
}

variable "service_account" {
  type    = string
  default = "logscale"
}

variable "ls_storage_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-ausov1-au2-logscale-storage20241223213943128500000001"
}
variable "ls_export_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-ausov1-au2-logscale-export20241223213943906000000002"
}

variable "ls_cloudtrail_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-ausov1-au2-cloudtrail-logs"
}