vpcs = {
  dmz = {
    vpc_id        = "vpc-0050dadffb6d585f7"
    subnet_ids    = ["subnet-06d83e2f9aa9371b6", "subnet-06e66333d72f64dc7"]
    subnet_cidrs  = ["10.232.144.0/23", "10.232.148.0/23"]
  },
  core = {
    vpc_id        = "vpc-053eb4d1a25a88bcb"
    subnet_ids    = ["subnet-051a2ff5798f6f48a", "subnet-0af26d07113c513fd"]
    subnet_cidrs  = ["10.232.152.0/24", "10.232.156.0/24"]
  }
}

security_groups = {
  # VPC Endpoint Service Request | ic-uksov1-uk1 | London DMZ | Facade-MediaPlayback
  vpce-svc-09c928fb370e3a329 = {
    name                    = "Facade-MediaPlayback"
    vpc_key                 = "dmz"   # ← must be core or dmz
    description             = "Facade-MediaPlayback"
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
      EndpointServiceId     = "vpce-svc-09c928fb370e3a329"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-09c928fb370e3a329"
      Request               = "SCTASK0107283"
    }
  }
}

vpc_endpoints = {
  # VPC Endpoint Service Request | ic-uksov1-uk1 | London DMZ | Facade-MediaPlayback
  vpce-svc-09c928fb370e3a329 = {
    service_name            = "com.amazonaws.vpce.eu-west-2.vpce-svc-09c928fb370e3a329"
    vpc_key                 = "dmz"   # ← must be core or dmz
    security_group_key      = "vpce-svc-09c928fb370e3a329"
    private_dns_enabled     = false
    tags = {
      Name                  = "Facade-MediaPlayback"
      Product               = "apifacade"
      ApplicationOwner      = "apifacade"
      InfrastructureOwner   = "Network Teams"
      EndpointServiceId     = "vpce-svc-09c928fb370e3a329"
      EndpointServiceName   = "com.amazonaws.vpce.eu-west-2.vpce-svc-09c928fb370e3a329"
      Request               = "SCTASK0107283"
      OriginatingAccount    = "571600874006"
    }
  }
}
