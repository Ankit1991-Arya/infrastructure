locals {
  region = "eu-central-1"

  records = {
    dl-airflow-euft = {
      route53_zone_name = "infra.eusov1.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-eu2.infra.eusov1.internal"
      endpoint_dns      = "vpce-06a0871e81826e359-a5zu7wom.vpce-svc-04119639419948da0.eu-central-1.vpce.amazonaws.com"
      dnszoneid         = "Z273ZU8SZ5RJPC"
    }
  }
}