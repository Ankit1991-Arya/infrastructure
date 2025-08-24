vpcs = {
  dmz = {
    vpc_id        = "vpc-49016a2f"
    subnet_ids    = ["subnet-6c999225", "subnet-a2b4e5f9"]
    subnet_cidrs  = ["172.31.184.0/23", "172.31.188.0/23"]
  },
  core = {
    vpc_id        = "vpc-380c675e"
    subnet_ids    = ["subnet-609b9029", "subnet-32b2e369"]
    subnet_cidrs  = ["172.31.192.0/20", "172.31.224.0/20"]
  },
}

security_groups = {

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
      EndpointServiceId     = "vpce-svc-0f1750aaf421da789"
      EndpointServiceName   = "com.amazonaws.vpce.us-east-1.vpce-svc-0f1750aaf421da789"
      Request               = "SCTASK0107750"
    }
  }
}


vpc_endpoints = {

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.us-east-1.vpce-svc-0f1750aaf421da789"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f1750aaf421da789"
      EndpointServiceName   = "com.amazonaws.vpce.us-east-1.vpce-svc-0f1750aaf421da789"
      Request               = "SCTASK0107750"
      OriginatingAccount    = "334442430111"
    }
  }
}
