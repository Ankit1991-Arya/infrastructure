variable "ad-domain-joiner-username" {
  description = ""
  type        = string
}

variable "chef-environment-name" {
  description = ""
  type        = string
}

variable "chef-server-name" {
  description = ""
  type        = string
}

variable "deployment-files-bucket" {
  description = "deployment-files-bucket"
  type        = string
  default     = ""
}

variable "domain-name" {
  description = "Internal/Windows domain (e.g. in.lab, inucn.com, incmp.com)"
  type        = string
  default     = ""
}

variable "ad-base-ou-name" {
  description = "ad-base-ou-name"
  type        = string
  default     = ""
}

variable "external-domain-name" {
  description = "External domain name for User Hub ACD Clusters (e.g. US:  dev.nice-incontact.com, nice-incontact.com  AUS:  nice-incontact.com, EUR:  niceincontact.com)"
  type        = string
  default     = ""
}

variable "external-domain-name-for-new-services" {
  description = "External domain name used for new services -- always based on niceincontact.com names (no dash) (e.g. dev.niceincontact.com, staging.niceincontact.com, niceincontact.com)"
  type        = string
  default     = ""
}

variable "ic-region-id" {
  description = "CXone region ID (not referencing platform region)"
  type        = string
}

variable "cxone-system-id" {
  description = "CXone System ID - https://nice-ce-cxone-prod.atlassian.net/wiki/spaces/IN/pages/16091369/System+IDs"
  type        = string
}

variable "cxone-area-id" {
  description = "CXone Area ID - https://nice-ce-cxone-prod.atlassian.net/wiki/spaces/IN/pages/15712544/Area+IDs"
  type        = string
}

#variable "SSLCertName" {
#  description = "The ARN of the SSL certificate created in this account and region (e.g. arn:aws:acm:us-west-2:545209810301:certificate/8a3d4b9e-5aa0-46fd-8381-0d1ab83b9621)"
#  type        = string
#  default     = ""
#}
