locals {
  region = "ap-southeast-2"

  records = {
    dl-airflow-aa = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-au1.infra.prod.internal"
      endpoint_dns      = "vpce-0abc5d79ac305806c-lnc2bblg.vpce-svc-0439d38703db3df5a.ap-southeast-2.vpce.amazonaws.com"
      dnszoneid         = "ZDK2GCRPAFKGO"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}