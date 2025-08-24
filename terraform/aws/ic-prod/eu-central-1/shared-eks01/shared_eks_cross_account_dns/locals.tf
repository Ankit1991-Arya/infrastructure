locals {
  region = "eu-central-1"

  records = {
    dl-airflow-af = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-eu1.infra.prod.internal"
      endpoint_dns      = "vpce-06e8c01de496efb41-2trq31xj.vpce-svc-0bd4920579b89d3eb.eu-central-1.vpce.amazonaws.com"
      dnszoneid         = "Z273ZU8SZ5RJPC"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}