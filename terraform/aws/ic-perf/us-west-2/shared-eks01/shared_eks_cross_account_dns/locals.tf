locals {
  region = "us-west-2"

  records = {
    dl-airflow-pfor = {
      route53_zone_name = "infra.perf.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.perf.internal"
      endpoint_dns      = "vpce-0522fab4cf8b9dc03-qyzyawoe.vpce-svc-0f23d0e0770ffeaf2.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}