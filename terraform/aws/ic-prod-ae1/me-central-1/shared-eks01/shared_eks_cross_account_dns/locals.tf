locals {
  region = "me-central-1"

  records = {
    dl-airflow-acae = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-ae1.infra.prod.internal"
      endpoint_dns      = "vpce-0d4aa844f9df45911-d41yhwf4.vpce-svc-022deae870e72d496.me-central-1.vpce.amazonaws.com"
      dnszoneid         = "Z07122992YCEUCB9A9570"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}