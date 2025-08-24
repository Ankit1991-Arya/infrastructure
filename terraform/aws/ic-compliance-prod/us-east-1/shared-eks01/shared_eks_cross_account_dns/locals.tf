locals {
  region = "us-east-1"

  records = {
    dl-airflow-cv = {
      route53_zone_name = "infra.complianceprod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na2.infra.complianceprod.internal"
      endpoint_dns      = "vpce-051f177e71149805c-3ih9t9at.vpce-svc-028bfe7c9d5802089.us-east-1.vpce.amazonaws.com"
      dnszoneid         = "Z7HUB22UULQXV"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}