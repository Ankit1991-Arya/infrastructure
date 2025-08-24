locals {
  region = "ca-central-1"

  records = {
    dl-airflow-am = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-ca1.infra.prod.internal"
      endpoint_dns      = "vpce-003543491b0a5b27a-82lbnf6b.vpce-svc-03f9ce1ad6de701db.ca-central-1.vpce.amazonaws.com"
      dnszoneid         = "ZRCXCF510Y6P9"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}