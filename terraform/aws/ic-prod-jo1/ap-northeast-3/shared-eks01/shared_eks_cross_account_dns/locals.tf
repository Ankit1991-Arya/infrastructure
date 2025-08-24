locals {
  region = "ap-northeast-3"

  records = {
    dl-airflow-acos = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-jo1.infra.prod.internal"
      endpoint_dns      = "vpce-05439127b883ffb91-1r5o1kgz.vpce-svc-0f1af64ead17392c9.ap-northeast-3.vpce.amazonaws.com"
      dnszoneid         = "Z376B5OMM2JZL2"
    },
    # ab = {
    #   route53_zone_name = ""
    #   a_record_name     = ""
    #   endpoint_dns      = ""
    # }
  }
}