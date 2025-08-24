# region = "us-west-2"

vpcs = {
  dmz = {
    vpc_id        = "vpc-a416f5c3"
    subnet_ids    = ["subnet-e6082b90", "subnet-06c3ca62"]
    subnet_cidrs  = ["172.28.192.0/23", "172.28.196.0/23"]
  },
  core = {
    vpc_id        = "vpc-24ff1f43"
    subnet_ids    = ["subnet-ee4c6c98", "subnet-58141a3c"]
    subnet_cidrs  = ["172.28.128.0/20", "172.28.160.0/20"]
  }
}

security_groups = {
  vpce-svc-09c2e813c86bc8089 = {
    name                    = "vpce-svc-09c2e813c86bc8089"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS API Facade for vpce-svc-09c2e813c86bc8089"
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
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-09c2e813c86bc8089"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-09c2e813c86bc8089"
      Request               = "SCTASK0107681"
    }
  },

  # VPC Endpoint Service Request | ic-dev | us-west-2 Oregon| DMZ VPC | Userhub Arrakis | wfo-platform-userhub-na1-endpoint
  vpce-svc-0f80f87f9337ff777 = {
    name                    = "vpce-svc-0f80f87f9337ff777"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "wfo-platform-userhub-na1-endpoint"
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
      Product               = "Platform"
      ApplicationOwner      = "Userhub Arrakis"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f80f87f9337ff777"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f80f87f9337ff777"
      Request               = "SCTASK0108148"
    }
  },

  MediaServicesSharedEksCore = {
    name                    = "MediaServicesSharedEksCore"
    vpc_key                 = "core"   # ← must be core or dmz
    description             = "Media Services Shared EKS Core"
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
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f47e0735c971af34"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f47e0735c971af34"
      Request               = "SCTASK0109204"
    }
  }

}

vpc_endpoints = {
  vpce-svc-09c2e813c86bc8089 = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-09c2e813c86bc8089"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-09c2e813c86bc8089"
    private_dns_enabled     = false
    tags = {
      Name                  = "vpce-svc-09c2e813c86bc8089"
      Product               = "IHub"
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-09c2e813c86bc8089"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-09c2e813c86bc8089"
      Request               = "SCTASK0107681"
    }
  },

  # VPC Endpoint Service Request | ic-dev | us-west-2 Oregon| DMZ VPC | Userhub Arrakis | wfo-platform-userhub-na1-endpoint
  vpce-svc-0f80f87f9337ff777 = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0f80f87f9337ff777"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-0f80f87f9337ff777"
    private_dns_enabled     = false
    tags = {
      Name                  = "wfo-platform-userhub-na1-endpoint"
      Product               = "Platform "
      ApplicationOwner      = "Userhub Arrakis"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f80f87f9337ff777"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f80f87f9337ff777"
      Request               = "SCTASK0108148"
    }
  },

  MediaServicesSharedEksCore = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0f47e0735c971af34"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "MediaServicesSharedEksCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "shared_eks01-end-point"
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0f47e0735c971af34"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f47e0735c971af34"
      Request               = "SCTASK0109204"
    }
  }
}
