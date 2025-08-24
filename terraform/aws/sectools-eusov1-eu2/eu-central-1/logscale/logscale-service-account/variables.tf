variable "oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::495599744015:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/E7B8FCDBE82A4629F35DB4D2C754C14A"
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
  default = "arn:aws:s3:::sectools-eusov1-eu2-logscale-storage20241223213940602800000002"
}
variable "ls_export_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-eusov1-eu2-logscale-export20241223213940491100000001"
}

variable "ls_cloudtrail_arn" {
  type    = string
  default = "arn:aws:s3:::sectools-eusov1-eu2-cloudtrail-logs"
}

variable "ls_cloudtrail_name" {
  type    = string
  default = "sectools-eusov1-eu2-cloudtrail-logs"
}

variable "sqs_subs_awslogs_name" {
  type    = string
  default = "sectools-eusov1-eu2-awslogs"
}

variable "sqs_subs_s3logs_name" {
  type    = string
  default = "sectools-eusov1-eu2-s3logs"
}