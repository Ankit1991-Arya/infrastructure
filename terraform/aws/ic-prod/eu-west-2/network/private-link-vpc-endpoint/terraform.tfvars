vpcs = {
  dmz = {
    vpc_id        = "vpc-04a09c20a0b9dd524"
    subnet_ids    = ["subnet-0dca3d01383928ba8", "subnet-0e1cd3d223ae5b73c"]
    subnet_cidrs  = ["10.4.106.0/23", "10.4.110.0/23"]
  },
  core = {
    vpc_id        = "vpc-0b19c0eb3e9513698"
    subnet_ids    = ["subnet-0fa096de1f6001e9a", "subnet-0217473390c43254c"]
    subnet_cidrs  = ["10.4.100.0/24", "10.4.96.0/24"]
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
      EndpointServiceId     = "vpce-svc-06733fa0366f2aa9f"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
      Request               = "SCTASK0108199"
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
      EndpointServiceId     = "vpce-svc-06733fa0366f2aa9f"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
      Request               = "SCTASK0107319"
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
      EndpointServiceId     = "vpce-svc-0bc144e2866a91157"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-0bc144e2866a91157"
      Request               = "SCTASK0107753"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-06733fa0366f2aa9f"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
      Request               = "SCTASK0108199"
      OriginatingAccount    = "432688485514"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-06733fa0366f2aa9f"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-06733fa0366f2aa9f"
      Request               = "SCTASK0107319"
      OriginatingAccount    = "432688485514"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.eu-west-2.vpce-svc-0bc144e2866a91157"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0bc144e2866a91157"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-0bc144e2866a91157"
      Request               = "SCTASK0107753"
      OriginatingAccount    = "918987959928"
    }
  }
}
