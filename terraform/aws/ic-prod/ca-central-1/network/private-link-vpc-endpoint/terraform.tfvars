vpcs = {
  dmz = {
    vpc_id        = "vpc-0eabfd10c29187bc4"
    subnet_ids    = ["subnet-0d6dc9a9154111650", "subnet-014f1b36f693442f9"]
    subnet_cidrs  = ["10.4.46.0/23", "10.4.42.0/23"]
  },
  core = {
    vpc_id        = "vpc-0c52f0e8f3ca94e74"
    subnet_ids    = ["subnet-077c673eaaaefa89e", "subnet-0c29b1d9191099293"]
    subnet_cidrs  = ["10.4.36.0/24", "10.4.32.0/24"]
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
      EndpointServiceId     = "vpce-svc-0537cac079bacb30a"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
      Request               = "SCTASK0108200"
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
      EndpointServiceId     = "vpce-svc-0537cac079bacb30a"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
      Request               = "SCTASK0107311"
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
      EndpointServiceId     = "vpce-svc-0b453d8e3cc1f7563"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0b453d8e3cc1f7563"
      Request               = "SCTASK0107739"
    }
  }
}



vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0537cac079bacb30a"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
      Request               = "SCTASK0108200"
      OriginatingAccount    = "432688485514"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = true
    tags = {
      Name                  = "OpenAPM-CoreVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0537cac079bacb30a"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0537cac079bacb30a"
      Request               = "SCTASK0107311"
      OriginatingAccount    = "063245935111"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ca-central-1.vpce-svc-0b453d8e3cc1f7563"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b453d8e3cc1f7563"
      EndpointServiceName   = "com.amazonaws.vpce.ca-central-1.vpce-svc-0b453d8e3cc1f7563"
      Request               = "SCTASK0107739"
      OriginatingAccount    = "918987959928"
    }
  }
}
