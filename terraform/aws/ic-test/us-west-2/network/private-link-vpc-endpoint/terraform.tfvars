vpcs = {
  dmz = {
    vpc_id        = "vpc-4aa4172d"
    subnet_ids    = ["subnet-dfcc1db8", "subnet-1b9b7052"]
    subnet_cidrs  = ["172.28.200.0/23", "172.28.204.0/23"]
  },
  core = {
    vpc_id        = "vpc-77a41710"
    subnet_ids    = ["subnet-c5cc1da2", "subnet-7b9b7032"]
    subnet_cidrs  = ["172.28.64.0/20", "172.28.96.0/20"]
  }
}

security_groups = {
  # VPC Endpoint Service Request | ic-test | us-west-2 Oregon | DMZ VPC | HA DR API Facade
  vpce-svc-0fd74697745fdef15 = {
    name                    = "vpce-svc-0fd74697745fdef15"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "For HA DR Initiative need to have APIs integrated behind API facade"
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
      ApplicationOwner      = "CXone_Platform_UH_Mars@nice.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0fd74697745fdef15"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0fd74697745fdef15"
      Request               = "SCTASK0107930"
    }
  },
  # VPC Endpoint Service Request | ic-test | us-west-2 Oregon | DMZ VPC | FIPS API Facade
  vpce-svc-0778f1cb5f6516eab = {
    name                    = "vpce-svc-0778f1cb5f6516eab"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS Onboaring of APIs on Facade [Test Env]."
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
      EndpointServiceId     = "vpce-svc-0778f1cb5f6516eab"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0778f1cb5f6516eab"
      Request               = "SCTASK0107743"
    }
  },

  UserHubArrakisDmz = {
    name                    = "UserHubArrakisDmz"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "User Hub Arrakis Dmz"
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
      EndpointServiceId     = "vpce-svc-078cca1ec0fff623c"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-078cca1ec0fff623c"
      Request               = "SCTASK0108157"
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
      EndpointServiceId     = "vpce-svc-087bcc3e785a2b48b"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-087bcc3e785a2b48b"
      Request               = "SCTASK0109884"
    }
  }
}

vpc_endpoints = {
  # VPC Endpoint Service Request | ic-test | us-west-2 Oregon | DMZ VPC | HA DR API Facade
  vpce-svc-09c2e813c86bc8089 = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0fd74697745fdef15"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-0fd74697745fdef15"
    private_dns_enabled     = false
    tags = {
      Name                  = "vpce-svc-0fd74697745fdef15"
      Product               = "Platform"
      ApplicationOwner      = "CXone_Platform_UH_Mars@nice.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0fd74697745fdef15"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0fd74697745fdef15"
      Request               = "SCTASK0107930"
      OriginatingAccount    = "477591777900"
    }
  },
  # VPC Endpoint Service Request | ic-test | us-west-2 Oregon | DMZ VPC | FIPS API Facade
  vpce-svc-0778f1cb5f6516eab = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0778f1cb5f6516eab"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-0778f1cb5f6516eab"
    private_dns_enabled     = false
    tags = {
      Name                  = "vpce-svc-0778f1cb5f6516eab"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0778f1cb5f6516eab"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0778f1cb5f6516eab"
      Request               = "SCTASK0107743"
      OriginatingAccount    = "934137132601"
    }
  },

  UserHubArrakisDmz = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-078cca1ec0fff623c"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "UserHubArrakisDmz"
    private_dns_enabled     = false
    tags = {
      Name                  = "vpce-svc-078cca1ec0fff623c"
      Product               = "Platform"
      ApplicationOwner      = "Userhub Arrakis"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-078cca1ec0fff623c"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-078cca1ec0fff623c"
      Request               = "SCTASK0107743"
      OriginatingAccount    = "934137132601"
    }
  },
  MediaServicesSharedEksCore = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-087bcc3e785a2b48b"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "MediaServicesSharedEksCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "shared_eks01-end-point"
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-087bcc3e785a2b48b"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-087bcc3e785a2b48b"
      Request               = "SCTASK0109884"
    }
  }
}