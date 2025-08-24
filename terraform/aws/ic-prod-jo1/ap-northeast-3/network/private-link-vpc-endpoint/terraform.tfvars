vpcs = {
  dmz = {
    vpc_id        = "vpc-05a5a5d477220140a"
    subnet_ids    = ["subnet-07f73eff4a5f0a769", "subnet-016d7078eba1b8be8"]
    subnet_cidrs  = ["10.230.36.0/23", "10.230.32.0/23"]
  },
  core = {
    vpc_id        = "vpc-07835507d71e5e3c4"
    subnet_ids    = ["subnet-08a5e1d4b8e583695", "subnet-0a93eb1093b59af58"]
    subnet_cidrs  = ["10.230.44.0/24", "10.230.40.0/24"]
  }
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
      EndpointServiceId     = "vpce-svc-07a3ed4e7ff5c1bbb"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
      Request               = "SCTASK0108193"
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
      EndpointServiceId     = "vpce-svc-07a3ed4e7ff5c1bbb"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
      Request               = "SCTASK0107313"
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
      EndpointServiceId     = "vpce-svc-02741de54d97c28e4"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-02741de54d97c28e4"
      Request               = "SCTASK0107751"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-07a3ed4e7ff5c1bbb"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
      Request               = "SCTASK0108193"
      OriginatingAccount    = "590340238334"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-CoreVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-07a3ed4e7ff5c1bbb"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-07a3ed4e7ff5c1bbb"
      Request               = "SCTASK0107313"
      OriginatingAccount    = "590340238334"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-02741de54d97c28e4"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-02741de54d97c28e4"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-3.vpce-svc-02741de54d97c28e4"
      Request               = "SCTASK0107751"
      OriginatingAccount    = "692416605838"
    }
  }
}
