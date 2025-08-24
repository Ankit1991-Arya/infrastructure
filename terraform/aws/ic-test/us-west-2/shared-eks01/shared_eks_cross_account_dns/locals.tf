locals {
  region = "us-west-2"

  records = {
    dl-airflow-to = {
      route53_zone_name = "infra.test.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.test.internal"
      endpoint_dns      = "vpce-0070c53ca24fe662a-5lef6ve9.vpce-svc-087bcc3e785a2b48b.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}
