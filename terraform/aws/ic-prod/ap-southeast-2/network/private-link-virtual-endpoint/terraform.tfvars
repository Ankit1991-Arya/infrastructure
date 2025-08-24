vpcs = {
  dmz = {
    vpc_id        = "vpc-564a4e32"
    subnet_ids    = ["subnet-226aa345", "subnet-c3966e8a"]
    subnet_cidrs  = ["10.209.192.0/23", "10.209.196.0/23"]
  },
  core = {
    vpc_id        = "vpc-ce494daa"
    subnet_ids    = ["subnet-d76ba2b0", "subnet-33976f7a"]
    subnet_cidrs  = ["10.209.128.0/23", "10.209.160.0/23"]
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
      EndpointServiceId     = "vpce-svc-0b990668da23e2504"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
      Request               = "SCTASK0108191"
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
      EndpointServiceId     = "vpce-svc-0b990668da23e2504"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
      Request               = "SCTASK0107306"
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
      EndpointServiceId     = "vpce-svc-0913ea585ab97cf69"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0913ea585ab97cf69"
      Request               = "SCTASK0107740"
    }
  }
}



vpc_endpoints = {

  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM Log Metrics DMZ"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b990668da23e2504"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
      Request               = "SCTASK0108191"
      OriginatingAccount    = "764988410719"
    }
  },

  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = true
    tags = {
      Name                  = "OpenAPM Log Metrics Core"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b990668da23e2504"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b990668da23e2504"
      Request               = "SCTASK0107306"
      OriginatingAccount    = "764988410719"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0913ea585ab97cf69"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0913ea585ab97cf69"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0913ea585ab97cf69"
      Request               = "SCTASK0107740"
      OriginatingAccount    = "918987959928"
    }
  }
}
