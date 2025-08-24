locals {
  region = "us-west-2"

  records = {
    dl-airflow-do = {
      route53_zone_name = "infra.dev.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.dev.internal"
      endpoint_dns      = "vpce-000f5ab7beadb8594-uwbjt8in.vpce-svc-0f47e0735c971af34.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    # ab = {
    #   route53_zone_name = "mediaservices.dev.internal"
    #   a_record_name     = "k8sapi-sharedeks02-wfo-vpce-na2.mediaservices.dev.internal"
    #   endpoint_dns      = "vpce-111f5ab7beadb8594-uwbjt8in.vpce-svc-1f47e0735c971af34.us-west-2.vpce.amazonaws.com"
    # }
  }
}