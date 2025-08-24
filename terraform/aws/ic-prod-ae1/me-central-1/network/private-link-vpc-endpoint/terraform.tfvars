vpcs = {
  dmz = {
    vpc_id        = "vpc-095963167426b715a"
    subnet_ids    = ["subnet-07eeaad0f2476d0dc", "subnet-0051d4a62860b105d"]
    subnet_cidrs  = ["10.230.236.0/23", "10.230.232.0/23"]
  },
  core = {
    vpc_id        = "vpc-0b2e79c20e82248ba"
    subnet_ids    = ["subnet-0784335f2a52e1ede", "subnet-04509e369d77eaa6b"]
    subnet_cidrs  = ["10.230.244.0/24", "10.230.240.0/24"]
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
      EndpointServiceId     = "vpce-svc-02bfd0d6e260dbece"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
      Request               = "SCTASK0108192"
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
      EndpointServiceId     = "vpce-svc-02bfd0d6e260dbece"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
      Request               = "SCTASK0107303"
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
      EndpointServiceId     = "vpce-svc-06d7abee4fe9522fd"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-06d7abee4fe9522fd"
      Request               = "SCTASK0107749"
    }
  }
}


vpc_endpoints = {
  OpenApmLogMetricsDmz = {
    service_name            = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-DmzVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-02bfd0d6e260dbece"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
      Request               = "SCTASK0108192"
      OriginatingAccount    = "362525016205"
    }
  },
  
  OpenApmLogMetricsCore = {
    service_name            = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "OpenApmLogMetricsCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "OpenAPM-CoreVPC"
      Product               = "OpenAPM"
      ApplicationOwner      = "SRE"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-02bfd0d6e260dbece"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-02bfd0d6e260dbece"
      Request               = "SCTASK0107303"
      OriginatingAccount    = "362525016205"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.me-central-1.vpce-svc-06d7abee4fe9522fd"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-06d7abee4fe9522fd"
      EndpointServiceName   = "com.amazonaws.vpce.me-central-1.vpce-svc-06d7abee4fe9522fd"
      Request               = "SCTASK0107749"
      OriginatingAccount    = "918987959928"
    }
  }
}
