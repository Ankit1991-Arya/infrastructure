locals {
  region = "eu-west-2"

  records = {
    dl-airflow-al = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-uk1.infra.prod.internal"
      endpoint_dns      = "vpce-063420b44e64c9699-9a9fe5ig.vpce-svc-0e551d66c9bcab206.eu-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z7K1066E3PUKB"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}