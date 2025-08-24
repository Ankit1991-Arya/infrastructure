data "aws_route53_zone" "this" {
  for_each     = local.records
  name         = "${each.value.route53_zone_name}."
  private_zone = true
}

resource "aws_route53_record" "a_record" {
  for_each = local.records
  zone_id  = data.aws_route53_zone.this[each.key].zone_id
  name     = each.value.a_record_name
  type     = "A" # Alias record still uses A-type
  # ttl      = 300
  alias {
    name                   = each.value.endpoint_dns
    zone_id                = each.value.dnszoneid
    evaluate_target_health = true
  }
}