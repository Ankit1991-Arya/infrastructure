variable "vpcs" {
  type = map(object({
    vpc_id        = string
    subnet_ids    = list(string)
    subnet_cidrs  = list(string)
  }))
}

variable "security_groups" {
  type = map(object({
    name        = string
    vpc_key     = string
    description = string
    ingress_rules = list(object({
      from_port     = number
      to_port       = number
      protocol      = string
      cidr_indexes  = list(number)
    }))
    tags = optional(map(string), {})
  }))
}

variable "vpc_endpoints" {
  type = map(object({
    service_name        = string
    vpc_key             = string
    security_group_key  = string
    private_dns_enabled = bool
    tags                = optional(map(string), {})
  }))
}