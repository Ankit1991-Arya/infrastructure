data "aws_route53_zone" "hosted_zone" {
  name = local.private_link_data.route53-verification-data.route53_zone_name
}

resource "aws_route53_record" "aws_service_private" {
  name    = local.private_link_data.route53-verification-data.service_domain_verification_name
  type    = local.private_link_data.route53-verification-data.route53_record_type
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  ttl     = 300
  records = [local.private_link_data.route53-verification-data.service_domain_verification_value]
}