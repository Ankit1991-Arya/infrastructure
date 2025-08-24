locals {
  region = "us-west-2"

  records = {
    dl-airflow-ao = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-na1.infra.prod.internal"
      endpoint_dns      = "vpce-0854f92dc1fb19e07-cqea4jgq.vpce-svc-0118ef5953dcb11f1.us-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z1YSA3EXCYUU9Z"
    },
    dl-airflow-am = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-ca1.infra.prod.internal"
      endpoint_dns      = "vpce-003543491b0a5b27a-82lbnf6b.vpce-svc-03f9ce1ad6de701db.ca-central-1.vpce.amazonaws.com"
      dnszoneid         = "ZRCXCF510Y6P9"
    },
    dl-airflow-af = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-eu1.infra.prod.internal"
      endpoint_dns      = "vpce-06e8c01de496efb41-2trq31xj.vpce-svc-0bd4920579b89d3eb.eu-central-1.vpce.amazonaws.com"
      dnszoneid         = "Z273ZU8SZ5RJPC"
    },
    dl-airflow-al = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-uk1.infra.prod.internal"
      endpoint_dns      = "vpce-063420b44e64c9699-9a9fe5ig.vpce-svc-0e551d66c9bcab206.eu-west-2.vpce.amazonaws.com"
      dnszoneid         = "Z7K1066E3PUKB"
    },
    dl-airflow-acae = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-ae1.infra.prod.internal"
      endpoint_dns      = "vpce-0d4aa844f9df45911-d41yhwf4.vpce-svc-022deae870e72d496.me-central-1.vpce.amazonaws.com"
      dnszoneid         = "Z07122992YCEUCB9A9570"
    },
    dl-airflow-aj = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-jp1.infra.prod.internal"
      endpoint_dns      = "vpce-0018be3b652d40ee8-wckowh3x.vpce-svc-0c164061281bfb2b4.ap-northeast-1.vpce.amazonaws.com"
      dnszoneid         = "Z2E726K9Y6RL4W"
    },
    dl-airflow-acos = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-jo1.infra.prod.internal"
      endpoint_dns      = "vpce-05439127b883ffb91-1r5o1kgz.vpce-svc-0f1af64ead17392c9.ap-northeast-3.vpce.amazonaws.com"
      dnszoneid         = "Z376B5OMM2JZL2"
    },
    dl-airflow-acsl = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-kr1.infra.prod.internal"
      endpoint_dns      = "vpce-0ad66bca6d2d4eaef-tzwmuuwr.vpce-svc-0f9222df477c16626.ap-northeast-2.vpce.amazonaws.com"
      dnszoneid         = "Z27UANNT0PRK1T"
    },
    dl-airflow-aa = {
      route53_zone_name = "infra.prod.internal"
      a_record_name     = "k8sapi-sharedeks01-wfo-vpce-au1.infra.prod.internal"
      endpoint_dns      = "vpce-0abc5d79ac305806c-lnc2bblg.vpce-svc-0439d38703db3df5a.ap-southeast-2.vpce.amazonaws.com"
      dnszoneid         = "ZDK2GCRPAFKGO"
    }
  }
}