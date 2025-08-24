locals {
  region = "ap-northeast-2"

  records = {
    dl-airflow-acsl = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-kr1.infra.prod.internal"
      endpoint_dns      = "vpce-0ad66bca6d2d4eaef-tzwmuuwr.vpce-svc-0f9222df477c16626.ap-northeast-2.vpce.amazonaws.com"
      dnszoneid         = "Z27UANNT0PRK1T"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}