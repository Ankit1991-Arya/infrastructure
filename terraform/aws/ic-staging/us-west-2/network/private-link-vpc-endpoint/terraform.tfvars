vpcs = {
  dmz = {
    vpc_id        = "vpc-29e1394e"
    subnet_ids    = ["subnet-89d6c4ff", "subnet-4860982f"]
    subnet_cidrs  = ["172.28.208.0/23", "172.28.212.0/23"]
  },
  core = {
    vpc_id        = "vpc-53b04a34"
    subnet_ids    = ["subnet-804e77f6", "subnet-769a7d11"]
    subnet_cidrs  = ["172.28.0.0/20", "172.28.32.0/20"]
  }
}

security_groups = {
  # VPC Endpoint Service Request | ic-staging | us-west-2 Oregon | DMZ VPC | FIPS API Facade
  vpce-svc-00eb1bbbe53bbc564 = {
    name                    = "vpce-svc-00eb1bbbe53bbc564"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS On-Boarding of APIs on Facade [Staging]"
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
      EndpointServiceId     = "vpce-svc-00eb1bbbe53bbc564"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-00eb1bbbe53bbc564"
      Request               = "SCTASK0107741"
    }
  },
  # VPC Endpoint Service Request | ic-staging | us-west-2 Oregon | DMZ VPC | HA DR Initiative API facade
  sg_ha_dr_apifacade_endpoint = {
    name                    = "sg_ha_dr_apifacade_endpoint"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "FIPS On-Boarding of APIs on Facade [Staging]"
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
      EndpointServiceId     = "vpce-svc-0f3e81d313fbb533d"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f3e81d313fbb533d"
      Request               = "SCTASK0109491"
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
      EndpointServiceId     = "vpce-svc-0dae791e274fc89c5"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0dae791e274fc89c5"
      Request               = "SCTASK0109888"
    }
  }    
}

vpc_endpoints = {
  # VPC Endpoint Service Request | ic-staging | us-west-2 Oregon | DMZ VPC | FIPS API Facade
  vpce-svc-00eb1bbbe53bbc564 = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-00eb1bbbe53bbc564"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-00eb1bbbe53bbc564"
    private_dns_enabled     = false
    tags = {
      Name                  = "vpce-svc-00eb1bbbe53bbc564"
      Product               = "IHub"
      ApplicationOwner      = "IHub/Sourav.Dutta@nice.com/+918007669004/Onkar.Hingne@nice.com/+919158893477/Chaitanya.Shenolikar@nice.com/+918308922788"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-00eb1bbbe53bbc564"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-00eb1bbbe53bbc564"
      Request               = "SCTASK0107741"
      OriginatingAccount    = "946153222386"
    }
  },
  # VPC Endpoint Service Request | ic-staging | us-west-2 Oregon | DMZ VPC | FIPS API Facade
  HA-DR-ApiFacade-Dmz = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0f3e81d313fbb533d"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "sg_ha_dr_apifacade_endpoint"
    private_dns_enabled     = false
    tags = {
      Name                  = "HA-DR-ApiFacade-Dmz"
      Product               = "Platform"
      ApplicationOwner      = "CXone_Platform_UH_Mars@nice.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-00eb1bbbe53bbc564"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0f3e81d313fbb533d"
      Request               = "SCTASK0109491"
      OriginatingAccount    = "194416699151"
    }
  },
  MediaServicesSharedEksCore = {
    service_name            = "com.amazonaws.vpce.us-west-2.vpce-svc-0dae791e274fc89c5"
    vpc_key                 = "core"   # ← must be core or dmz
    security_group_key      = "MediaServicesSharedEksCore"
    private_dns_enabled     = false
    tags = {
      Name                  = "shared_eks01-end-point"
      Product               = "Infrastructure"
      ApplicationOwner      = "Cloud Native Core/devops-cloud-native-core@NiceinContact.com"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-0dae791e274fc89c5"
      EndpointServiceName   = "com.amazonaws.vpce.us-west-2.vpce-svc-0dae791e274fc89c5"
      Request               = "SCTASK0109888"
    }
  }    
}
