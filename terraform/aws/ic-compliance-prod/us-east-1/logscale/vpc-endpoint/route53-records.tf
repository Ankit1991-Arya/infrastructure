data "aws_route53_zone" "infra" {
  name         = "${var.infra_hosted_zone}."
  private_zone = true
}

resource "aws_route53_record" "logscale_cname_record" {
  zone_id    = data.aws_route53_zone.infra.id
  name       = "logscale.${data.aws_route53_zone.infra.name}"
  type       = "CNAME"
  ttl        = 300
  records    = [module.corenetwork_privatelink_endpoint.vpc_endpoint_dns["logscale-corenetwork"]]
  depends_on = [module.corenetwork_privatelink_endpoint]
}

resource "aws_route53_record" "logscale_ingest_cname_record" {
  zone_id    = data.aws_route53_zone.infra.id
  name       = "logscale-ingest.${data.aws_route53_zone.infra.name}"
  type       = "CNAME"
  ttl        = 300
  records    = [module.corenetwork_privatelink_endpoint.vpc_endpoint_dns["logscale-corenetwork"]]
  depends_on = [module.corenetwork_privatelink_endpoint]
}