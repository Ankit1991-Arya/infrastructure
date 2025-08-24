vpcs = {
  dmz = {
    vpc_id        = "vpc-0a39b9fccb2e5a456"
    subnet_ids    = ["subnet-0907128b6d44a129e", "subnet-0a12b7f52f69d47f8"]
    subnet_cidrs  = ["10.9.42.0/23", "10.9.46.0/23"]
  },
  core = {
    vpc_id        = "vpc-0011ddf0fc5d5c591"
    subnet_ids    = ["subnet-0fa839fd9c266b4a6", "subnet-0558f1061f5144634"]
    subnet_cidrs  = ["10.9.160.0/24", "10.9.164.0/24"]
  },
  core_and_voice = {
    vpc_id        = "vpc-0011ddf0fc5d5c591"
    subnet_ids    = ["subnet-0fa839fd9c266b4a6", "subnet-0558f1061f5144634"]
    subnet_cidrs  = ["10.9.160.0/24", "10.9.164.0/24", "10.9.176.0/23", "10.9.180.0/23"]
  }
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
      EndpointServiceId     = "vpce-svc-0795d9e2beac53966"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0795d9e2beac53966"
      Request               = "SCTASK0107748"
    }
  },

  MediaServicesSharedEksCore = {
    name                    = "MediaServicesSharedEksCore"
    vpc_key                 = "core_and_voice" 
    description             = "Media Services Shared EKS Core"
    ingress_rules = [
      {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_indexes        = [0, 1, 2, 3]
      },
      {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_indexes        = [0, 1, 2, 3]
      }
    ]
    tags = {
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f23d0e0770ffeaf2"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f23d0e0770ffeaf2"
      Request               = "SCTASK0109886"
    }
  }
  
}


vpc_endpoints = {

  FipsApiFacadeIhubDmz = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0795d9e2beac53966"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "FipsApiFacadeIhubDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "FIPS Facade IHub DMZ"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0795d9e2beac53966"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0795d9e2beac53966"
      Request               = "SCTASK0107748"
      OriginatingAccount    = "918987959928"
    }
  },

  MediaServicesSharedEksCore = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0f23d0e0770ffeaf2"
    vpc_key                 = "core_and_voice"
    security_group_key      = "MediaServicesSharedEksCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "shared_eks01-end-point"
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f23d0e0770ffeaf2"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f23d0e0770ffeaf2"
      Request               = "SCTASK0109886"
    }
  }

}
