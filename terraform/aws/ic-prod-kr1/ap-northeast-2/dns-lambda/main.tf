module "dns-lambda-route53-provision" {
  for_each = local.hosted_zones
  source   = "github.com/inContact/terraform-dns-lambda-config.git//modules/dns-lambda?ref=v1"

  name_suffix            = each.key
  cross_account_role_arn = each.value.cross_account_role_arn
  route_53_region        = each.value.route_53_region
}