locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
  }

  allow_public_access = true
  vpc_cidr            = "10.200.0.0/16"
  nat_gw_ips = [
    "13.238.77.108/32",
    "54.253.168.82/32",
    "13.239.213.52/32"
  ]

  temporary_admin_ips = [
    # CNC Team
    "190.181.6.122/32",
    "200.105.212.183/32",
    # Omilia Athens Office
    # "195.97.98.18/32",
    # FortiClient
    "66.35.27.114/32"
  ]

  temporary_access_ips = concat(local.temporary_admin_ips, [
    "49.36.51.33/32",
    # CNC Team
    "200.105.212.180/32"
  ])

  # CIS Hardened images
  cis_ec2_ami_id = "ami-030bc574f749dfd11" # cis-ec2-cxone-20250529-5c3d875
  cis_eks_ami_id = "ami-01be36eca30ca1237" # cis-eks-1.32-al2023-cxone-20250529-5c3d875

  additional_security_groups = ["niceincontact-rapid7-scan-assistant-sg-e804ad"]

  custom_ecr_repos = [
    { name = "kubebuilder/kube-rbac-proxy", version = "v0.8.0" },
    { name = "argoproj/argocd", version = "2.9.0" }
  ]
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "omilia" {
  source = "github.com/inContact/omilia-terraform-modules?ref=wip-ausov-snowflake"

  # Tagging
  #===============================================================================
  #===============================================================================
  name   = "ocp"
  env    = "prod"
  region = "ap-southeast-2"

  #===============================================================================
  # Network
  #===============================================================================

  vpc_cidr                   = local.vpc_cidr
  vpc_id                     = "vpc-0726330be3acef11d"
  public_subnet_cidrs        = concat(["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"], local.temporary_access_ips)
  private_subnet_cidrs       = ["10.200.128.0/19", "10.200.160.0/19", "10.200.192.0/19"]
  database_subnet_cidrs      = ["10.200.6.0/24", "10.200.7.0/24", "10.200.8.0/24"]
  public_subnet_ids          = ["subnet-0984b187bc82c74d5", "subnet-08a46793085a5418e", "subnet-07cf5025f00c14445"]
  private_subnet_ids         = ["subnet-05e1a1b73397765c5", "subnet-08ba63ef855adbf8f", "subnet-0de650f5841e3c6c0"]
  database_subnet_ids        = ["subnet-0ac2de39a71d5279b", "subnet-0c4f599f5d72967bb", "subnet-04f3ff44d52f04159"]
  private_nat_eip_public_ips = local.nat_gw_ips
  private_route_table_ids    = ["rtb-09c670801fff9ff10", "rtb-02db09fb15972d487", "rtb-0d8fa33793072ae4c"]

  # Additional set of CIDRS to allow in the database security groups
  # database_rtb_routes = [
  #   "192.168.0.0/16", # omilia-vpn
  #   "10.110.0.0/21"   # jenkins
  # ]

  #===============================================================================
  # EKS
  #===============================================================================
  cluster_version                                = "1.32"
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access_cidrs          = [local.vpc_cidr]
  cluster_endpoint_private_access                = false
  cluster_endpoint_public_access                 = true
  cluster_endpoint_public_access_cidrs           = concat(local.nat_gw_ips, local.temporary_admin_ips)
  external_access_cidrs                          = local.allow_public_access ? ["0.0.0.0/0"] : local.temporary_access_ips
  internal_access_cidrs                          = concat([local.vpc_cidr], local.temporary_access_ips)

  map_roles = [
    {
      "groups" : ["system:masters"],
      "rolearn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GroupAccess-SystemEngineering",
      "username" : "GroupAccess-SystemEngineering"
    },
    {
      "groups" : ["system:masters"],
      "rolearn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GroupAccess-DevOpsAdmin",
      "username" : "GroupAccess-DevOpsAdmin"
    }
  ]

  #===============================================================================
  # S3 buckets
  #===============================================================================

  # cluster_buckets, bucketname, map of namespaces that a SA will be created for access.
  cluster_buckets = {
    "nlu"            = ["autoc-api", "fusion-api", "ml-nlu-api", "rb-nlu-api", "nlu-operator"],
    "billing-logs"   = ["billing-api"],
    "deepasr-models" = ["deepasr", "deepvb"],
    "tes"            = ["testing-studio-api"],
    "configurations" = ["miniapps-api-spring", "diamant"],
    "storage-api"    = ["storage-api", "flume", "exports-api"],
    "iam-bundles" = [
      "iam-api",
      "idm-api",
      "iam-energon",
      "exports-api",
      "fusion-api",
      "console-api",
      "integrations",
      "metrics-api",
      "miniapps-api-spring",
      "pathfinder-api",
      "dialogs-api",
      "testing-studio-api",
      "console-vb-mw",
      "envs-manager-api",
    "orc-api"],
    "kafka-connect" = ["kafka-connect"],
    "dwh-hadoop"    = ["kafka-connect", "dialogs-api", "exports-api", "airflow"],
    "airflow"       = ["airflow"],
    "tts-models"    = ["tts-engine", "pytriton-server"],
    "exports-api"   = ["exports-api"],
    "orc-api"       = ["orc-api"]
  }

  #===============================================================================
  # Cluster AddOns
  #===============================================================================

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    amazon-cloudwatch-observability = {
      most_recent = true
    }
  }
  #===============================================================================
  # Node Groups
  #===============================================================================
  node_groups = {
    base2 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 6
      instance_types             = ["m7i.xlarge"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      image_id                   = local.cis_eks_ami_id

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "Base nodegroup"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType = "base"
      }

      tags = {
        NodeGroupType = "base"
        Name          = "k8s-prod-base"
        OwnerCode     = ""
        BudgetDpt     = "Cloud Engineering"
      }
    }
    deepasr2 = {
      min_size                   = 2
      max_size                   = 10
      desired_size               = 2
      instance_types             = ["m7i.xlarge"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      image_id                   = local.cis_eks_ami_id

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "deepASR nodegroup"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType = "deepasr"
      }

      tags = {
        NodeGroupType = "deepasr"
        Name          = "k8s-prod-deepasr"
        OwnerCode     = ""
        BudgetDpt     = "ASR"
      }
    }
    nlu2 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 6
      instance_types             = ["m7i.2xlarge"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      image_id                   = local.cis_eks_ami_id

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "NLU nodegroup"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType = "nlu"
      }

      tags = {
        NodeGroupType = "nlu"
        Name          = "k8s-prod-nlu"
        OwnerCode     = ""
        BudgetDpt     = "NLU"
      }
    }
    nluCritical2 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 6
      instance_types             = ["m7i.2xlarge"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      image_id                   = local.cis_eks_ami_id

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "NLU nodegroup for Business Critical apps"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType       = "nlu"
        NLUBusinessCritical = "true"
      }

      tags = {
        NodeGroupType = "nlu"
        Name          = "k8s-prod-nlu"
        OwnerCode     = ""
        BudgetDpt     = "NLU"
      }
    }
    dialog2 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 5
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      image_id                   = local.cis_eks_ami_id

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "Dialog nodegroup"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType = "dialog"
      }

      tags = {
        NodeGroupType = "dialog"
        Name          = "k8s-prod-dialog"
        OwnerCode     = ""
        BudgetDpt     = "dialog"
      }
    }
    analytics = {
      min_size                   = 4
      max_size                   = 10
      desired_size               = 7
      instance_types             = ["m7i.xlarge"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

      update_config = {
        max_unavailable = 1 # or set `max_unavailable_percent`
      }

      description = "Analytics nodegroup"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 75
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = {
        NodeGroupType = "analytics"
      }

      tags = {
        NodeGroupType = "analytics"
        Name          = "k8s-stage-analytcs"
        OwnerCode     = ""
        BudgetDpt     = "Cloud Engineering"
      }
    }
  }


  #===============================================================================
  # Route53
  #===============================================================================
  create_zone = true                # Whether to create the subdomain
  domain      = "nicecxone-sov1.au" #
  subdomain   = "ocp"

  #===============================================================================
  # ACM
  #===============================================================================
  services            = ["", "pub"]
  acm_route53_zone_id = "Z00924631PUS5QOF298N2"

  #===============================================================================
  # EFS
  #===============================================================================
  throughput_mode  = "elastic" // Valid values: bursting, provisioned
  provisioned_mibs = 10        // Not applicable if throughput_mode is "bursting"

  access_points = {
    "apps/airflow/airflow-logs" = {
      posix_user = {
        gid            = "50000"
        uid            = "50000"
        secondary_gids = null
      }
      creation_info = {
        gid         = "50000"
        uid         = "50000"
        permissions = "0755"
      }
    }
    "apps/airflow/airflow-dags" = {
      posix_user = {
        gid            = "50000"
        uid            = "50000"
        secondary_gids = null
      }
      creation_info = {
        gid         = "50000"
        uid         = "50000"
        permissions = "0755"
      }
    }
    "apps/airflow/airflow-sql-scripts" = {
      posix_user = {
        gid            = "50000"
        uid            = "50000"
        secondary_gids = null
      }
      creation_info = {
        gid         = "50000"
        uid         = "50000"
        permissions = "0755"
      }
    }
  }

  #===============================================================================
  # RDS
  #===============================================================================
  db_create = true      // true or false
  db_mode   = "cluster" // Supported values: "cluster" for Aurora, "single" for single instance with no reader.

  db_name                    = "cms" // if left empty it will be set to ${name}. Must contain 1 to 16 alphanumeric characters. First character must be a letter.Cannot be a word reserved by the database engine.
  username                   = "cms"
  db_backup_retention_period = 30            // The days to retain backups for. Must be between 0 and 35
  db_backup_window           = "02:00-05:00" // The daily time range (in UTC) during which automated backups are created if they are enabled. Example: "09:46-10:16"
  db_skip_final_snapshot     = true
  instance_class             = "db.t3.medium"
  cluster_pgroup_family      = "aurora-mysql8.0"
  cluster_engine             = "aurora-mysql"
  cluster_engine_version     = "8.0.mysql_aurora.3.04.1"


  mysql_max_connections      = 6200
  mysql_max_user_connections = 6200

  autostart_enabled = false
  autostop_enabled  = false

  psql_instance_class         = "db.t3.medium"
  psql_cluster_pgroup_family  = "aurora-postgresql13"
  psql_cluster_engine         = "aurora-postgresql"
  psql_cluster_engine_version = "13.12"
  psql_cluster_members        = 2

  // global rds is enabled on primary region

  #===============================================================================
  # MSK
  #===============================================================================
  msk_enabled = true

  #===============================================================================
  # ElastiCache Redis
  #===============================================================================

  redis_create                     = true
  redis_mode                       = "single"
  redis_node_type                  = "cache.t2.micro"
  redis_engine_version             = "6.x"
  redis_port                       = 6379
  redis_parameter_group_name       = "default.redis6.x"
  redis_automatic_failover_enabled = false
  redis_snapshot_window            = "02:00-05:00"
  redis_snapshot_retention_limit   = 30
  redis_maintenance_window         = "sun:07:00-sun:09:00"

  // single mode
  redis_single_mode_nodes_count = 2

  # // cluster mode
  # redis_cluster_mode_shards_count                  = 2
  # redis_cluster_mode_read_only_replicas_per_shards = 1

  #===============================================================================
  # Document DB
  #===============================================================================

  // single cluster
  docdb_single_cluster_create         = true
  docdb_single_cluster_instance_class = "db.t3.medium"
  docdb_engine_version                = "4.0.0"
  docdb_cluster_members               = 2
  # global docdb is enabled on primary region

  #===============================================================================
  # Secret Management and IAM
  #===============================================================================
  deployments = [
    "metrics-api",
    "dialogs-api",
    "exports-api",
    "airflow",
    "kafka-connect",
    "omaccounts",
    "console-api",
    "console-ui",
    "envs-manager-api",
    "storage-api",
    "datasets-api",
    "agi-connector",
    "chat-connector",
    "facebook-connector",
    "tts-proxy",
    "dashboard",
    "diamant",
    "diamant-controller",
    "hubot",
    "iam-api",
    "iam-energon",
    "idm-api",
    "autoc-api",
    "fusion-api",
    "ml-nlu-api",
    "rb-nlu-api",
    "nlu-operator",
    "om-syncher-api",
    "deepasr",
    "deepvb",
    "js-api",
    "miniapps-api-spring",
    "orc-api",
    "xml-service",
    "testing-studio-api",
    "drtviewer",
    "knowledge-base-api",
    "kamailio",
    "omivr",
    "console-notifications",
    "hubot-sandbox",
    "integrations",
    "encryption-service",
    "smr",
    "biostoreserver",
    "agent-vb-middleware",
    "console-vb-mw",
    "deepvb"
  ]

  #===============================================================================
  # CloudFront
  #===============================================================================
  cloudfront_create      = true
  cloudfront_price_class = "PriceClass_100"

  #===============================================================================
  # ArgoCD
  #===============================================================================
  create_ocp_services_app = true

  scm_url                       = "https://github.com/omilia"
  argocd_root_app_repo          = "https://github.com/omilia/cxone-app-of-apps-templates.git"
  argocd_root_app_repo_revision = "main"
  scm_user                      = "inContactBuildUser"
  ssm_scm_user_token            = "/github/prod/users/inContactBuildUser1"
  ssm_azure_acr_secret          = "omilia/azure/acr"

  argo_enable_ingress     = false
  argo_serverExtraArgs    = ["--insecure"]
  argo_dexServerExtraArgs = ["--disable-tls"]

  argocd_params_cm = {
    "server.basehref"   = "/argocd"
    "server.rootpath"   = "/argocd"
    "server.dex.server" = "http://argocd-dex-server:5556"
  }

  #===============================================================================
  # Shared AWS secrets
  #===============================================================================

  create_shared_secrets = true

  #===============================================================================
  # Secrets Manager
  #===============================================================================

  service_usage = [
    { name = "omaccounts", mysql = true },
    { name = "console-api", mysql = true, mongodb = true },
    { name = "console-ui" },
    { name = "iam-energon" },
    { name = "idm-api", mysql = true },
    { name = "iam-api", mongodb = true, postgresql = false },
    { name = "datasets-api", postgresql = true },
    { name = "om-syncher-api" },
    { name = "tts-proxy" },
    { name = "orc-api", postgresql = true },
    { name = "hubot", mysql = true },
    { name = "miniapps-api-spring", mysql = true },
    { name = "envs-manager-api", postgresql = true },
    { name = "diamant", mysql = true },
    { name = "agi-connector", mysql = true },
    { name = "chat-connector", mysql = true },
    { name = "fusion-api", mysql = true },
    { name = "autoc-api", mysql = true },
    { name = "ml-nlu-api", mysql = true },
    { name = "rb-nlu-api", mysql = true },
    { name = "deepasr" },
    { name = "storage-api", postgresql = true },
    { name = "knowledge-base-api" },
    { name = "testing-studio-api", postgresql = true },
    { name = "voipmonitor", mysql = true },
    { name = "kamailio", mysql = true },
    { name = "biostoreserver", postgresql = true },
    { name = "hubot-sandbox", mysql = true },
    { name = "integrations", mysql = true },
    { name = "exports-api", mysql = true },
    { name = "kafka-connect" },
    { name = "dialogs-api" },
    { name = "airflow", postgresql = true },
    { name = "encryption-service", mysql = true },
    { name = "smr" },
    { name = "agent-vb-middleware" },
    { name = "deepvb" },
    { name = "console-vb-mw" },
    { name = "console-notifications" },
    { name = "pytriton_server" },
    { name = "tts-engine" }
  ]

  # databases for which only users needs to created and not DB.
  excluded_databases = ["miniapps_api_spring", "chat_connector", "agi_connector", "integrations"]

  #===============================================================================
  # Karpenter
  #===============================================================================

  enable_karpenter   = true
  karpenter_revision = "0.35.4"

  #===============================================================================
  # Auto-start-stop
  #===============================================================================

  enable_auto_start = false
  enable_auto_stop  = false

  #===============================================================================
  # OpenSearch
  #===============================================================================

  create_opensearch             = true
  os_instance_count             = 3
  os_instance_type              = "i3.xlarge.search"
  os_enable_monitoring          = false
  os_allow_cross_cluster_search = true

  ### ECR Repos
  create_ecr_repos = true
  sync_acr_to_ecr  = false
  scan_type        = "ENHANCED"
  scanning_rules = [{
    scan_frequency = "CONTINUOUS_SCAN"
    filter         = "*"
  }]
  ecr_repos = concat(local.custom_ecr_repos, [
    { name = "integrations", version = "1.6.0" },
    { name = "omaccounts", version = "26.0.8.1" },
    { name = "testing-studio/testingstudio-api", version = "1.10.0" },
    { name = "diamant", version = "10.34.1" },
    { name = "hubot", version = "5.7.0" },
    { name = "ocp-console/console-ui/mfe-initializr", version = "0.1.2" },
    { name = "agi-connector", version = "4.15.4" },
    { name = "chat-connector", version = "8.6.1" },
    { name = "dashboard", version = "5.7.1" },
    { name = "envs-manager-api", version = "1.19.1" },
    { name = "deepasr", version = "7.11.0" },
    { name = "smr", version = "7.5.0.0" },
    { name = "nlu/operator", version = "1.1.4.0" },
    { name = "nlu-service-api", version = "1.6.0" },
    { name = "ml-nlu-service-api", version = "1.6.0" },
    { name = "nluengine-api", version = "8.0.3" },
    { name = "dataset-api", version = "1.5.2" },
    { name = "autocorrect-server", version = "3.0.1" },
    { name = "autocorrect-api", version = "1.4.0" },
    { name = "iam-api", version = "3.5.1" },
    { name = "idm-api", version = "3.5.1" },
    { name = "idm-energon", version = "3.5.1" },
    { name = "authz-sidecar", version = "1.7.0" },
    { name = "ocp-console/console-ui/mfe-server", version = "1.15.0" },
    { name = "ocp-console/console-api", version = "1.15.0" },
    { name = "ml-server", version = "3.2.4-ocp" },
    { name = "fusion-nlu-service-api", version = "1.5.0" },
    { name = "flume-storage-service-sink", version = "1.1.3" },
    { name = "orchestrator-api", version = "1.26.0" },
    { name = "miniapps-api-spring", version = "1.5.0" },
    { name = "js-api", version = "1.7.0" },
    { name = "storage-service-api", version = "2.19.0" },
    { name = "exports-api", version = "1.8.1" },
    { name = "kafka-connect", version = "1.6.0" },
    { name = "tts-proxy", version = "6.4.1" },
    { name = "encryption-service", version = "2.0.1" },
    { name = "dialogs-api", version = "2.1.0" },
    { name = "kamailio_omcti", version = "5.4.6.0-ssl-dyn" },
    { name = "omivr", version = "2.1.7" },
    { name = "kafka-connectors", version = "1.6.0" },
    { name = "dialog-log-shipper", version = "1.0.3" },
    { name = "biostore", version = "6.18.0" },
    { name = "agent-vb-mw", version = "6.18.0" },
    { name = "deepvb", version = "6.18.0" },
    { name = "deepvbmiddleware", version = "6.18.0" },
    { name = "kafka-connect", version = "1.15.0" },
    { name = "tts-pytriton-server", version = "1.2.0" },
    { name = "tts-engine", version = "2.2.0" },
    { name = "ocp-console/console-notifications", version = "1.16.0" },
    { name = "ml-server", version = "ml-init-files-3.0.0" },
    { name = "metrics-api", version = "3.2.2" },
    { name = "snowflake-airflow-dags", version = "1.4.0" }
  ])

  # az_artifacts = [
  #   { name = "miniapps-frontend-vue", version = "3.29.0", s3_bucket = "ocp-prod-ap-southeast-2-configurations" },
  #   { name = "ocp-nlu-xpacks", version = "8.0.3", s3_bucket = "ocp-prod-ap-southeast-2-nlu", folder = "fusion/xpacks" },
  #   { name = "biomodel-en-us", version = "5.4.3", s3_bucket = "ocp-prod-ap-southeast-2-deepasr-models", folder = "deepvb" }
  # ]

  #======================
  # PCA
  #======================

  create_pca = true
  pca_validity = {
    type  = "YEARS"
    value = 10
  }

  pca_algorithm = {
    key     = "RSA_4096"
    signing = "SHA256WITHRSA"
  }

  pca_subject = {
    common_name         = "omilia-ausov1-au2"
    country             = "US"
    locality            = "Sandy"
    state               = "Utah"
    organization        = "Nice"
    organizational_unit = "omilia"
  }

  #======================
  # Cloudwatch alarms
  #======================

  # Used by lambda function to send alarm notifications at Slack channel
  slack_webhook              = ""
  cloudwatch_email_recipient = null # "systemengineering@nice.com"
  enable_cloudwatch_alarms   = true

  #======================
  # SIP
  #======================

  prod_peers = ["twilio", "omilia_pbx", "prod"]

  kamailio_asg_desired_instance_size  = 3
  rtpengine_asg_desired_instance_size = 3

  certificate_name_crt = "ocp-prod/kamailio/cert"
  certificate_name_key = "ocp-prod/kamailio/cert_key"

  kamailio_ami_id  = local.cis_ec2_ami_id
  rtpengine_ami_id = local.cis_ec2_ami_id

  #===============================================================================
  # SNOWFLAKE ACCOUNT CONFIGS
  #===============================================================================
  snowflake_organization        = "CXONE"
  snowflake_account             = "OMILIA_AU2_AUSOV1"
  enable_snowflake_private_link = false

  #===============================================================================
  # Snowflake databases
  #===============================================================================

  snowflake_databases = {
    OCP_DB = {
      schemas = ["DIAMANT", "REPORTS", "VB", "USER_INTERACTIONS", "AUDIT", "TABLEAU_USERS"]
    }
  }

  #===============================================================================
  # Snowflake warehouses
  #===============================================================================

  snowflake_warehouses = {
    SERVING_WH = {
      name                                = "SERVING_WH"
      warehouse_type                      = "STANDARD"
      warehouse_size                      = "X-Small"
      auto_suspend                        = 60
      auto_resume                         = "true"
      max_concurrency_level               = 8
      statement_queued_timeout_in_seconds = 0
      statement_timeout_in_seconds        = 172800
      enable_query_acceleration           = "false"
      query_acceleration_max_scale_factor = 0
    }
    BATCH_WH = {
      name                                = "BATCH_WH"
      warehouse_type                      = "STANDARD"
      warehouse_size                      = "X-Small"
      auto_suspend                        = 60
      auto_resume                         = "true"
      max_concurrency_level               = 8
      statement_queued_timeout_in_seconds = 0
      statement_timeout_in_seconds        = 172800
      enable_query_acceleration           = "false"
      query_acceleration_max_scale_factor = 0
    }
    REALTIME_WH = {
      name                                = "REALTIME_WH"
      warehouse_type                      = "STANDARD"
      warehouse_size                      = "X-Small"
      auto_suspend                        = 60
      auto_resume                         = "true"
      max_concurrency_level               = 8
      statement_queued_timeout_in_seconds = 0
      statement_timeout_in_seconds        = 172800
      enable_query_acceleration           = "false"
      query_acceleration_max_scale_factor = 0
    }
    ANALYST_WH = {
      name                                = "ANALYST_WH"
      warehouse_type                      = "STANDARD"
      warehouse_size                      = "X-Small"
      auto_suspend                        = 60
      auto_resume                         = "true"
      max_concurrency_level               = 8
      statement_queued_timeout_in_seconds = 0
      statement_timeout_in_seconds        = 172800
      enable_query_acceleration           = "false"
      query_acceleration_max_scale_factor = 0
    }
  }

  #===============================================================================
  # Snowflake roles
  #===============================================================================

  snowflake_roles = {
    METRICS = {
      name    = "METRICS"
      comment = "The role for metrics-api user"

      warehouse_grants = [
        {
          warehouse_name = "SERVING_WH"
          privileges     = ["USAGE"]
        }
      ]

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          privileges    = ["USAGE"]
        }
      ]

      table_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_future     = true
          privileges    = ["SELECT"]
        }
      ]
    }
    AIRFLOW = {
      name    = "AIRFLOW"
      comment = "The role for airflow user"

      warehouse_grants = [
        {
          warehouse_name = "BATCH_WH"
          privileges     = ["USAGE"]
        },
        {
          warehouse_name = "REALTIME_WH"
          privileges     = ["USAGE"]
        }
      ]

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          on_all        = true
          privileges    = ["USAGE", "CREATE TABLE"]
        },
        {
          database_name = "OCP_DB"
          on_future     = true
          privileges    = ["USAGE", "CREATE TABLE"]
        }
      ]

      table_grants = [
        {
          database_name  = "OCP_DB"
          schema_name    = "DIAMANT"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "DIAMANT"
          on_future      = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "REPORTS"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "REPORTS"
          on_future      = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "VB"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "VB"
          on_future      = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "USER_INTERACTIONS"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "USER_INTERACTIONS"
          on_future      = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "AUDIT"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "AUDIT"
          on_future      = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "TABLEAU_USERS"
          on_all         = true
          all_privileges = true
        },
        {
          database_name  = "OCP_DB"
          schema_name    = "TABLEAU_USERS"
          on_future      = true
          all_privileges = true
        }
      ]
    }
    DIAMANTINGESTION = {
      name    = "DIAMANTINGESTION"
      comment = "The role for diamant snowflake streaming connector"

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          privileges    = ["USAGE", "CREATE TABLE", "CREATE STAGE", "CREATE PIPE"]
        }
      ]
    }
    AUDITINGESTION = {
      name    = "AUDITINGESTION"
      comment = "The role for Audit-events snowflake streaming connector"

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "AUDIT"
          privileges    = ["USAGE", "CREATE TABLE", "CREATE STAGE", "CREATE PIPE"]
        }
      ]
    }
    VBINGESTION = {
      name    = "VBINGESTION"
      comment = "The role for VB snowflake streaming connector"

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "VB"
          privileges    = ["USAGE", "CREATE TABLE", "CREATE STAGE", "CREATE PIPE"]
        }
      ]
    }
    TAGSINGESTION = {
      name    = "TAGSINGESTION"
      comment = "The role for Tags snowflake streaming connector"

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "USER_INTERACTIONS"
          privileges    = ["USAGE", "CREATE TABLE", "CREATE STAGE", "CREATE PIPE"]
        }
      ]
    }
    ANALYSTADMIN = {
      name    = "ANALYSTADMIN"
      comment = "Role used by ocp support team to create analyst users"

      account_grants = ["CREATE USER"]
    }
    ANALYST = {
      name    = "ANALYST"
      comment = "The role for analysts"

      warehouse_grants = [
        {
          warehouse_name = "ANALYST_WH"
          privileges     = ["USAGE"]
        }
      ]

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          on_all        = true
          privileges    = ["USAGE"]
        },
        {
          database_name = "OCP_DB"
          on_future     = true
          privileges    = ["USAGE"]
        }
      ]

      table_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          on_future     = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_future     = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "VB"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "VB"
          on_future     = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "USER_INTERACTIONS"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "USER_INTERACTIONS"
          on_future     = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "AUDIT"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "AUDIT"
          on_future     = true
          privileges    = ["SELECT"]
        }
      ]
    }
    TABLEAU = {
      name    = "TABLEAU"
      comment = "The role for tableau user"

      warehouse_grants = [
        {
          warehouse_name = "BATCH_WH"
          privileges     = ["USAGE"]
        }
      ]

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "TABLEAU_USERS"
          privileges    = ["USAGE"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          privileges    = ["USAGE"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          privileges    = ["USAGE"]
        }
      ]

      table_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_all        = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "REPORTS"
          on_future     = true
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "TABLEAU_USERS"
          table_name    = "USERS"
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          table_name    = "DIALOGS"
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          table_name    = "DIALOG_STEPS"
          privileges    = ["SELECT"]
        },
        {
          database_name = "OCP_DB"
          schema_name   = "DIAMANT"
          table_name    = "DIALOG_STEP_EVENTS"
          privileges    = ["SELECT"]
        }
      ]
    }
    TABLEAUADMIN = {
      name    = "TABLEAUADMIN"
      comment = "The role for tableau-admin user"

      warehouse_grants = [
        {
          warehouse_name = "BATCH_WH"
          privileges     = ["USAGE"]
        }
      ]

      database_grants = [
        {
          database_name = "OCP_DB"
          privileges    = ["USAGE"]
        }
      ]

      schema_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "TABLEAU_USERS"
          privileges    = ["USAGE"]
        }
      ]

      table_grants = [
        {
          database_name = "OCP_DB"
          schema_name   = "TABLEAU_USERS"
          table_name    = "USERS"
          privileges    = ["SELECT", "UPDATE", "INSERT", "DELETE"]
        }
      ]
    }
  }

  #===============================================================================
  # Snowflake service accounts
  #===============================================================================

  snowflake_service_accounts = {
    "metrics-api" = {
      name              = "metrics-api"
      comment           = "The user used by metrics-api"
      default_namespace = "OCP_DB.REPORTS"
      default_warehouse = "SERVING_WH"
      default_role      = "METRICS"
      generate_rsa_key  = true
    }
    "snowflake-airflow" = {
      name              = "snowflake-airflow"
      comment           = "The user used by snowflake-airflow service"
      default_namespace = "OCP_DB.DIAMANT"
      default_warehouse = "BATCH_WH"
      default_role      = "AIRFLOW"
      generate_rsa_key  = true
    }
    "tableau" = {
      name              = "tableau"
      comment           = "The user used by tableau api"
      type              = "legacy"
      default_namespace = "OCP_DB.TABLEAU_USERS"
      default_warehouse = "BATCH_WH"
      default_role      = "TABLEAU"
      generate_password = true
      generate_rsa_key  = true
    }
    "tableau-admin" = {
      name              = "tableau-admin"
      comment           = "The admin user used by tableau api"
      type              = "legacy"
      default_namespace = "OCP_DB.TABLEAU_USERS"
      default_warehouse = "BATCH_WH"
      default_role      = "TABLEAUADMIN"
      generate_password = true
      generate_rsa_key  = true
    }
    "Diamant-connector" = {
      name              = "Diamant-connector"
      comment           = "The user of the Diamant snowflake streaming kafka connector"
      default_namespace = "OCP_DB.DIAMANT"
      default_role      = "DIAMANTINGESTION"
      generate_rsa_key  = true
    }
    "Audit-connector" = {
      name              = "Audit-connector"
      comment           = "The user of the Audit snowflake streaming kafka connector"
      default_namespace = "OCP_DB.AUDIT"
      default_role      = "AUDITINGESTION"
      generate_rsa_key  = true
    }
    "Vb-connector" = {
      name              = "Vb-connector"
      comment           = "The user of the VB snowflake streaming kafka connector"
      default_namespace = "OCP_DB.VB"
      default_role      = "VBINGESTION"
      generate_rsa_key  = true
    }
    "Tags-connector" = {
      name              = "Tags-connector"
      comment           = "The user of the Tags snowflake streaming kafka connector"
      default_namespace = "OCP_DB.USER_INTERACTIONS"
      default_role      = "TAGSINGESTION"
      generate_rsa_key  = true
    }
  }
  #===============================================================================
  # Snowflake named users
  #===============================================================================

  snowflake_users = {}

  #===============================================================================
  # Snowflake network policies
  #===============================================================================

  create_snowflake_network_policy             = false # set to true to enable network policies
  enable_snowflake_network_policy_for_account = false # set to true to enable network policies
  attach_snowflake_network_policy             = false # set to true to enable network policies
  snowflake_allowed_ips                       = []    # define in this variable the list of ip cidrs that should be allowed access to snowflake
  snowflake_blocked_ips                       = []



  #======================
  # Custom options
  #======================
  mysql_default_character_set = "utf8"
  mysql_default_collation     = "utf8_general_ci"

  standard_tags            = local.standard_tags
  deployment_principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ServiceAccess-infrastructure-live-terraform"
  disable_slack_webhook    = true
  argocd_repo_name         = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/argoproj/argocd"
  argocd_image_tag         = "v2.9.0-94d9f0e"

  cluster_additional_security_groups   = local.additional_security_groups
  kamailio_additional_security_groups  = local.additional_security_groups
  rtpengine_additional_security_groups = local.additional_security_groups

  #cluster_additional_worker_policies = [
  #  "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/EKSLogsWriter"
  #]

  # Auth
  argocd_enable_github_login = true
  argocd_auth_policy         = "role:admin"

  argocd_github_access = [
    {
      name  = "nice-cxone"
      teams = ["autopilot-omilia"]
    }
  ]

  # Additional Alert Manager topics
  #alertmanager_topics = [
  #  # "alertmanager"
  #]

  # SNS Funnel
  #alarm_rename_rules = [
  #  {
  #    "pattern"  = ".*redis-node([0-9]+)-connections",
  #    "new_name" = "Omilia-FedRAMP-ocp-opensearch[AWS/ElastiCache=>CurrConnections]"
  #  },
  #  {
  #    "pattern"  = "Endpoint(.+)",
  #    "new_name" = "Omilia-FedRAMP-ocp-endpoints[AWS/EKS=>Endpoint=>\\1]"
  #  },
  #  {
  #    "pattern"  = ".+",
  #    "new_name" = "Omilia-FedRAMP-ocp-endpoints[None]"
  #  }
  #]

  # Target BMC accounts
  #  allowed_cross_account_subscriptions = [
  #    #"751344753113" # ic-compliance-prod
  #  ]
  #
  #  sns_funnel_variables = {
  #    ALARM_REGION_NAME = "AUSOV1 (ap-southeast-2)"
  #  }

  # WAF (disabled)
  #use_waf     = true
  #waf_lb_name = "k8s-istiogatewayexter-505c5ba9db"
}
