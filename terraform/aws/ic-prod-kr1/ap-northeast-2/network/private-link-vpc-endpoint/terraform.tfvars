vpcs = {
  dmz = {
    vpc_id        = "vpc-0a6fec358fec78ca5"
    subnet_ids    = ["subnet-053cece5258555ab9", "subnet-0c8ca183ca2464e12"]
    subnet_cidrs  = ["10.230.160.0/23", "10.230.164.0/23"]
  },
  core = {
    vpc_id        = "vpc-02a0dbf83275748a5"
    subnet_ids    = ["subnet-0aeebe86cdcd4fee4", "subnet-0630d260aee93d82f"]
    subnet_cidrs  = ["10.230.172.0/24", "10.230.168.0/24"]
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
      EndpointServiceId     = "vpce-svc-0aeb5428d45b956a7"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
      Request               = "SCTASK0108195"
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
      EndpointServiceId     = "vpce-svc-0aeb5428d45b956a7"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
      Request               = "SCTASK0107324"
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
      EndpointServiceId     = "vpce-svc-0ae1567431171bf7a"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0ae1567431171bf7a"
      Request               = "SCTASK0107742"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0aeb5428d45b956a7"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
      Request               = "SCTASK0108195"
      OriginatingAccount    = "744126299712"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = true
    tags = {
      Name                  = "OpenAPM-CoreVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0aeb5428d45b956a7"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0aeb5428d45b956a7"
      Request               = "SCTASK0107324"
      OriginatingAccount    = "744126299712"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0ae1567431171bf7a"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0ae1567431171bf7a"
      EndpointServiceName   = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0ae1567431171bf7a"
      Request               = "SCTASK0107742"
      OriginatingAccount    = "814740517824"
    }
  }
}
