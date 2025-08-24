locals {
  region = "us-west-2"

  records = {
    dl-airflow-ao = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.prod.internal"
      endpoint_dns      = "vpce-0854f92dc1fb19e07-cqea4jgq.vpce-svc-0118ef5953dcb11f1.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}