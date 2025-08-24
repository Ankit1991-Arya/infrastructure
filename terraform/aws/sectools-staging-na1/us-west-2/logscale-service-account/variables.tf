variable "oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::992382563823:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/7DF317D64ECA96C3AB3FEF7A0AA45188"
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
  default = "arn:aws:s3:::sectools-na1-logscale-storage20240624194411488700000001"
}
variable "ls_export_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-na1-logscale-export20240624194411488800000002"
}