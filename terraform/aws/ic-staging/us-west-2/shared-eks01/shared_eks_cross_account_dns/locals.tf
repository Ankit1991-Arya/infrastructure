locals {
  region = "us-west-2"

  records = {
    dl-airflow-so = {
      route53_zone_name = "infra.staging.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.staging.internal"
      endpoint_dns      = "vpce-086b365c326107dd8-eq3pgmbe.vpce-svc-0dae791e274fc89c5.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}