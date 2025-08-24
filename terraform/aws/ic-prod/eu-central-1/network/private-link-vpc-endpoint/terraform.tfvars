vpcs = {
  dmz = {
    vpc_id        = "vpc-9f1b74f7"
    subnet_ids    = ["subnet-e888a280", "subnet-b5f781cf"]
    subnet_cidrs  = ["10.208.64.0/23", "10.208.68.0/23"]
  },
  core = {
    vpc_id        = "vpc-9a0768f2"
    subnet_ids    = ["subnet-1abe9472", "subnet-1d81f767"]
    subnet_cidrs  = ["10.208.0.0/23", "10.208.32.0/23"]
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
      EndpointServiceId     = "vpce-svc-0cf72ae65c84de511"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
      Request               = "SCTASK0108198"
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
      EndpointServiceId     = "vpce-svc-0cf72ae65c84de511"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
      Request               = "SCTASK0107322"
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
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-00a99cf084d8e7201"
      Request               = "SCTASK0107752"
    }
  }
}



vpc_endpoints = {

  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM Log Metrics DMZ"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0cf72ae65c84de511"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
      Request               = "SCTASK0108198"
      OriginatingAccount    = "498107153657"
    }
  },

  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM Log Metrics Core"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0cf72ae65c84de511"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0cf72ae65c84de511"
      Request               = "SCTASK0107322"
      OriginatingAccount    = "498107153657"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.eu-central-1.vpce-svc-00a99cf084d8e7201"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-00a99cf084d8e7201"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-00a99cf084d8e7201"
      Request               = "SCTASK0107752"
      OriginatingAccount    = "918987959928"
    }
  }
}
