locals {
  region = "ap-northeast-1"

  records = {
    dl-airflow-aj = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-jp1.infra.prod.internal"
      endpoint_dns      = "vpce-0018be3b652d40ee8-wckowh3x.vpce-svc-0c164061281bfb2b4.ap-northeast-1.vpce.amazonaws.com"
      dnszoneid         = "Z2E726K9Y6RL4W"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}