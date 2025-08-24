locals {
  region = "eu-west-2"

  records = {
    dl-airflow-uklo = {
      route53_zone_name = "infra.uksov1.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-uk2.infra.uksov1.internal"
      endpoint_dns      = "vpce-08817fee6b41c4b4d-umg05vpt.vpce-svc-010d9594126845f09.eu-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z7K1066E3PUKB"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}