
vpcs = {
  dmz = {
    vpc_id        = "vpc-07f530ed6eaa44a85"
    subnet_ids    = ["subnet-0261e84071f3b38d5", "subnet-0eb8118606803b6f7"]
    subnet_cidrs  = ["10.232.68.0/23", "10.232.64.0/23"]
  },
  core = {
    vpc_id        = "vpc-049053c0decb4f27e"
    subnet_ids    = ["subnet-007f52b4dba727bf3", "subnet-0de4a2613329ac08a"]
    subnet_cidrs  = ["10.232.76.0/24", "10.232.72.0/24"]
  },
}


security_groups = {
  Facade-MediaPlaybackDmz = {
    name                    = "Facade-MediaPlaybackDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "Required for the cxone RT screen monitoring via the Supervisor application"
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
      Product               = "apifacade"
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0c5ba48671f2d1e33"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0c5ba48671f2d1e33"
      Request               = "SCTASK0106840"
    }
  },

  FipsApiFacadeIhubDmz = {
    name                    = "FipsApiFacadeIhubDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS On-Boarding of APIs on Facade [EUSOV1]"
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
      EndpointServiceId     = "vpce-svc-0f0d58b3b0ec60951"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0f0d58b3b0ec60951"
      Request               = "SCTASK0107745"
    }
  }
}



vpc_endpoints = {
  Facade-MediaPlaybackDmz = {
    service_name            = "com.amazonaws.vpce.eu-central-1.vpce-svc-0c5ba48671f2d1e33"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "Facade-MediaPlaybackDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "Facade-MediaPlaybackDmz"
      Product               = "apifacade"
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0c5ba48671f2d1e33"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0c5ba48671f2d1e33"
      Request               = "SCTASK0106840"
      OriginatingAccount    = "851725389895"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.eu-central-1.vpce-svc-0f0d58b3b0ec60951"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f0d58b3b0ec60951"
      EndpointServiceName   = "com.amazonaws.vpce.eu-central-1.vpce-svc-0f0d58b3b0ec60951"
      Request               = "SCTASK0107745"
      OriginatingAccount    = "851725389895"
    }
  }
}
