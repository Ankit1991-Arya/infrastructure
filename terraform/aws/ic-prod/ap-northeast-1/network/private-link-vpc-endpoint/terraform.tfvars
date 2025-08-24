vpcs = {
  dmz = {
    vpc_id        = "vpc-071babdb5951be18c"
    subnet_ids    = ["subnet-0f3e72a0baf8d6f20", "subnet-088d5ecc32ae8bd69"]
    subnet_cidrs  = ["10.5.42.0/23", "10.5.46.0/23"]
  },
  core = {
    vpc_id        = "vpc-0d9e75de1ad7f364d"
    subnet_ids    = ["subnet-033188015e0a1f408", "subnet-0982c4e93df73a842"]
    subnet_cidrs  = ["10.5.32.0/24", "10.5.36.0/24"]
  },
}

security_groups = {
  OpenApmLogMetricsDmz = {
    name                    = "OpenApmLogMetricsDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "OpenAPM Log Metrics"
    ingress_rules = [
      {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      },
      {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      },
      {
        from_port           = 4318
        to_port             = 4318
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      }
    ]
    tags = {
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b58d4b2bfac2c4e6"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
      Request               = "SCTASK0108197"
    }
  },

  OpenApmLogMetricsCore = {
    name                    = "OpenApmLogMetricsCore"
    vpc_key                 = "core"   # ← must be core or dmz
    description             = "OpenAPM Log Metrics"
    ingress_rules = [
      {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      },
      {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      },
      {
        from_port           = 4318
        to_port             = 4318
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      }
    ]
    tags = {
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b58d4b2bfac2c4e6"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
      Request               = "SCTASK0107316"
    }
  },

  FipsApiFacadeIhubDmz = {
    name                    = "FipsApiFacadeIhubDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS API-Facade IHub"
    ingress_rules = [
      {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      },
      {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_indexes        = [0, 1]
      }
    ]
    tags = {
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-05a60aff58c1eaffc"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-05a60aff58c1eaffc"
      Request               = "SCTASK0107740"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b58d4b2bfac2c4e6"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
      Request               = "SCTASK0108197"
      OriginatingAccount    = "309071122176"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = true
    tags = {
      Name                  = "OpenAPM-CoreVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b58d4b2bfac2c4e6"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0b58d4b2bfac2c4e6"
      Request               = "SCTASK0107316"
      OriginatingAccount    = "309071122176"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-05a60aff58c1eaffc"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-05a60aff58c1eaffc"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-05a60aff58c1eaffc"
      Request               = "SCTASK0107740"
      OriginatingAccount    = "918987959928"
    }
  }
}
