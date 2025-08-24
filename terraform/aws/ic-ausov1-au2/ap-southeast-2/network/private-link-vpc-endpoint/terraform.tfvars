vpcs = {
  dmz = {
    vpc_id        = "vpc-02e21396a14abfa38"
    subnet_ids    = ["subnet-0f3d8aaa938d8fde6", "subnet-0afb8aa62d12d3584"]
    subnet_cidrs  = ["10.230.100.0/23", "10.230.96.0/23"]
  },
  core = {
    vpc_id        = "vpc-0c2ca34187d6a3288"
    subnet_ids    = ["subnet-0f5d759bae6e62cb6", "subnet-0808100c5745e8a12"]
    subnet_cidrs  = ["10.230.104.0/24", "10.230.108.0/24"]
  },
}


security_groups = {
  Facade-MediaPlaybackDmz = {
    name                    = "Facade-MediaPlaybackDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS On-Boarding of APIs on Facade [AUSOV1]"
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
      EndpointServiceId     = "vpce-svc-0b0f30e107381e793"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b0f30e107381e793"
      Request               = "SCTASK0107281"
    }
  },

  FipsApiFacadeIhubDmz = {
    name                    = "FipsApiFacadeIhubDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS On-Boarding of APIs on Facade [AUSOV1]"
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
      EndpointServiceId     = "vpce-svc-0e606da5fec27e9a4"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0e606da5fec27e9a4"
      Request               = "SCTASK0107746"
    }
  }
}



vpc_endpoints = {
  Facade-MediaPlaybackDmz = {
    service_name            = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b0f30e107381e793"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "Facade-MediaPlaybackDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "Facade-MediaPlaybackDmz"
      Product               = "apifacade"
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0b0f30e107381e793"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0b0f30e107381e793"
      Request               = "SCTASK0107281"
      OriginatingAccount    = "637423329662"
    }
  },

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0e606da5fec27e9a4"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0e606da5fec27e9a4"
      EndpointServiceName   = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0e606da5fec27e9a4"
      Request               = "SCTASK0107746"
      OriginatingAccount    = "637423329662"
    }
  }
}
