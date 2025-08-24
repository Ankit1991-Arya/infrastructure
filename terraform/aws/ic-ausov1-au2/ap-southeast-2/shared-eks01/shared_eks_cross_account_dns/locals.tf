locals {
  region = "ap-southeast-2"

  records = {
    dl-airflow-ausy = {
      route53_zone_name = "infra.ausov1.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-au2.infra.ausov1.internal"
      endpoint_dns      = "vpce-02a54167782fe2081-dwi08enp.vpce-svc-042fcc858afb3a949.ap-southeast-2.vpce.amazonaws.com"
      dnszoneid         = "ZDK2GCRPAFKGO"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}