variable "oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::975050239252:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/32785D7B2A6549C9CEE1E28EFAB22847"
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
  default = "arn:aws:s3:::sectools-frm-na2-logscale-storage20241223213938085700000002"
}
variable "ls_export_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-frm-na2-logscale-export20241223213937996900000001"
}