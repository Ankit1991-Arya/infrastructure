module "snowflake_route53_zone" {
  source = "github.com/inContact/omilia-terraform-modules.git//modules/route53_zone?ref=wip-ausov-snowflake"

  count = var.enable_snowflake_private_link ? 1 : 0

  zones = {
    "privatelink.snowflakecomputing.com" = {
      comment       = "privatelink.snowflakecomputing.com"
      force_destroy = true
    }
  }

  private_zone = true
  vpc_id       = local.vpc_id
}

resource "aws_route53_record" "snowflake_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_snowflake_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "regionless_snowflake_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_regionless_snowflake_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "regionless_snowflake_url_with_hyphens" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_regionless_snowflake_name_with_hyphens
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "snwoflake_ocsp_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_snowflake_ocsp_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "regionless_snowflake_ocsp_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_regionless_snowflake_ocsp_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "regionless_snowflake_ocsp_url_with_hyphens" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_regionless_snowflake_ocsp_name_with_hyphens
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "snowsight_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_snowsight_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}

resource "aws_route53_record" "regionless_snowsight_url" {
  count           = var.enable_snowflake_private_link ? 1 : 0
  zone_id         = values(module.snowflake_route53_zone[0].zone_id)[0]
  name            = local.private_regionless_snowsight_name
  type            = "CNAME"
  allow_overwrite = true
  records         = [local.snowflake_endpoint_dns_entry]
  ttl             = "300"
}