locals {
  hosted_zones = {
    "DataReporting" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-DataReporting"
      route_53_region        = "us-east-1"
    }
    "DigitalEngagement" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-DigitalEngagement"
      route_53_region        = "us-east-1"
    }
    "Infra" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-Infra"
      route_53_region        = "us-east-1"
    }
    "Integrations" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-Integrations"
      route_53_region        = "us-east-1"
    }
    "Omnichannel" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-Omnichannel"
      route_53_region        = "us-east-1"
    }
    "Platform" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-Platform"
      route_53_region        = "us-east-1"
    }
    "SelfService" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-SelfService"
      route_53_region        = "us-east-1"
    }
    "MediaServices" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-MediaServices"
      route_53_region        = "us-east-1"
    }
    "CEA" = {
      cross_account_role_arn = "arn:aws:iam::637423616941:role/ServiceAccess-dns-lambda-route53-CEA"
      route_53_region        = "us-east-1"
    }
  }
}