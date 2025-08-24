vpcs = {
  dmz = {
    vpc_id        = "vpc-6db2b309"
    subnet_ids    = ["subnet-00f3b176", "subnet-a6ebc1c2"]
    subnet_cidrs  = ["172.25.128.0/23", "172.25.132.0/23"]
  },
  core = {
    vpc_id        = "vpc-b0e0e0d4"
    subnet_ids    = ["subnet-2a9dd05c", "subnet-6d6f5a09"]
    subnet_cidrs  = ["172.25.64.0/20", "172.25.96.0/20"]
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
      EndpointServiceId     = "vpce-svc-001048a4529f99c52"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-001048a4529f99c52"
      Request               = "SCTASK0107952"
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
      EndpointServiceId     = "vpce-svc-0b332f1fa75e39f41"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0b332f1fa75e39f41"
      Request               = "SCTASK0107747"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-001048a4529f99c52"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-001048a4529f99c52"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-001048a4529f99c52"
      Request               = "SCTASK0107952"
      OriginatingAccount    = "672696122715"
    }
  },
  
  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0b332f1fa75e39f41"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b332f1fa75e39f413"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0b332f1fa75e39f413"
      Request               = "SCTASK0107747"
      OriginatingAccount    = "918987959928"
    }
  }
}
