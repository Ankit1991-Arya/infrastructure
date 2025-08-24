locals {
  standard_tags = {
    ApplicationOwner    = "AppOps@nice.com"
    InfrastructureOwner = "systemengineering@nice.com"
    Product             = "Omilia"
  }

  temporary_access_ips = [
    "64.158.65.162/32",
    "136.38.113.166/32",
    "67.214.231.34/32",
    "66.35.27.214/32",
    "64.98.227.28/32"
  ]
}

module "omilia" {
  source = "github.com/inContact/omilia-terraform-modules?ref=f7a45c92f88a277ddd8cb45d187533a59b314966"

  # Tagging
  #===============================================================================
  #===============================================================================
  name   = "ocp"
  env    = "prod"
  region = "us-east-1"

  #===============================================================================
  # Network
  #===============================================================================

  vpc_cidr                   = "10.200.0.0/16"
  vpc_id                     = "vpc-0207b6f1b84936372"
  public_subnet_cidrs        = concat(["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24", "66.35.27.114/32", "66.103.20.137/32", "34.235.37.99/32", "18.210.46.58/32", "44.209.83.12/32"], local.temporary_access_ips)
  private_subnet_cidrs       = ["10.200.3.0/24", "10.200.4.0/24", "10.200.5.0/24"]
  database_subnet_cidrs      = ["10.200.6.0/24", "10.200.7.0/24", "10.200.8.0/24"]
  public_subnet_ids          = ["subnet-071d514206ccc7b5e", "subnet-005bcbaef03972755", "subnet-0de4a8e151a38691c"]
  private_subnet_ids         = ["subnet-03d97397467080b9b", "subnet-034896856317868ca", "subnet-04ab23cd5b7f8a28d"]
  database_subnet_ids        = ["subnet-0c6e391f408e5666b", "subnet-05428283da96664f9", "subnet-01febeaf4a044fb16"]
  private_nat_eip_public_ips = ["34.235.37.99/32", "18.210.46.58/32", "44.209.83.12/32"]
  private_route_table_ids    = ["rtb-09298d81d78d43074", "rtb-06812978b0cf1614f", "rtb-0dacb92ab6f713893"]

  # Additional set of CIDRS to allow in the database security groups
  #database_rtb_routes = [
  #  "192.168.0.0/16", # omilia-vpn
  #  "10.110.0.0/21"   # jenkins
  #]

  #===============================================================================
  # EKS
  #===============================================================================
  cluster_version                                = "1.30"
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access_cidrs = [
    "10.200.0.0/16"
  ]

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = [
    # NAT GWs (Enabled to have public access)
    "34.235.37.99/32",
    "18.210.46.58/32",
    "44.209.83.12/32",
    # CNC IPs
    "66.35.27.114/32",
    "66.103.20.137/32",
    # CoreNetwork NAT GWs (ic-compliance-prod)
    "34.198.153.46/32",
    "34.198.42.255/32"
  ]

  external_access_cidrs = [
    # Omilia Athens Office
    "195.97.98.18/32",
    # FortiClient SLC
    "66.35.27.114/32",
    "66.103.20.137/32",
    # CoreNetwork NAT GWs (ic-compliance-prod)
    "34.198.153.46/32",
    "34.198.42.255/32"
  ]

  internal_access_cidrs = [
    #  "192.168.0.0/16", # vpn
    "10.200.0.0/16"
  ]

  map_roles = [
    {
      "groups" : ["system:masters"],
      "rolearn" : "arn:aws:iam::730335349404:role/GroupAccess-DevOpsAdmin",
      "username" : "GroupAccess-DevOpsAdmin"
    },
    {
      "groups" : ["system:masters"],
      "rolearn" : "arn:aws:iam::730335349404:role/GroupAccess-SystemEngineering",
      "username" : "GroupAccess-SystemEngineering"
    },
    {
      "groups" : ["system:masters"],
      "rolearn" : "arn:aws:iam::730335349404:role/GroupAccess-SRE",
      "username" : "GroupAccess-SRE"
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
    "configurations" = ["miniapps-api", "diamant"],
    "storage-api"    = ["storage-api", "flume"],
    "iam-bundles"    = ["iam-api", "idm-api", "iam-energon", "exports-api", "fusion-api", "envs-manager-api", "orc-api", "miniapps-api", "integrations", "testing-studio-api", "dialogs-api"],
    "kafka-connect"  = ["kafka-connect"],
    "dwh-hadoop"     = ["kafka-connect", "dialogs-api", "exports-api", "airflow"],
    "airflow"        = ["airflow"]
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
    base1 = {
      min_size                   = 2
      max_size                   = 10
      desired_size               = 3
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

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
        Name          = "k8s-stage-base"
        OwnerCode     = ""
        BudgetDpt     = "Cloud Engineering"
      }
    }
    deepasr1 = {
      min_size                   = 2
      max_size                   = 10
      desired_size               = 2
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

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
        Name          = "k8s-stage-deepasr"
        OwnerCode     = ""
        BudgetDpt     = "ASR"
      }
    }
    nlu1 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 5
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

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
        Name          = "k8s-stage-nlu"
        OwnerCode     = ""
        BudgetDpt     = "NLU"
      }
    }
    nluCritical2 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 5
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

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
        Name          = "k8s-demo-nlu"
        OwnerCode     = ""
        BudgetDpt     = "NLU"
      }
    }
    dialog1 = {
      min_size                   = 3
      max_size                   = 10
      desired_size               = 4
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true

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
        Name          = "k8s-stage-dialog"
        OwnerCode     = ""
        BudgetDpt     = "dialog"
      }
    }
    voip1 = {
      min_size                   = 2
      max_size                   = 10
      desired_size               = 3
      instance_types             = ["m7i.large"]
      ami_type                   = "AL2023_x86_64_STANDARD"
      enable_bootstrap_user_data = true
      update_config = {
        max_unavailable = 2 # or set `max_unavailable_percent`
      }

      description = "VoIP nodegroup"

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
        NodeGroupType = "voip"
      }

      tags = {
        NodeGroupType = "voip"
        Name          = "k8s-stage-voip"
        OwnerCode     = ""
        BudgetDpt     = "OSCS"
      }
    }
  }

  #===============================================================================
  # Route53
  #===============================================================================
  create_zone = true                # Whether to create the subdomain
  domain      = "nicecxone-gov.com" #
  subdomain   = "ocp"

  #===============================================================================
  # ACM
  #===============================================================================
  services            = ["", "pub"]
  acm_route53_zone_id = "Z03784681JPBJ4X48JPMG"

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
    "miniapps-api",
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
    "smr"
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
    { name = "miniapps-api", mysql = true },
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
    { name = "biostore", postgresql = true },
    { name = "hubot-sandbox", mysql = true },
    { name = "integrations", mysql = true },
    { name = "exports-api", mysql = true },
    { name = "kafka-connect" },
    { name = "dialogs-api" },
    { name = "airflow", postgresql = true },
    { name = "encryption-service", mysql = true },
    { name = "smr" }
  ]

  # databases for which only users needs to created and not DB.
  excluded_databases = ["miniapps_api", "chat_connector", "agi_connector", "integrations"]

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
  ecr_repos = [
    { name = "integrations", version = "1.3.0" },
    { name = "omaccounts", version = "24.0.5.1" },
    { name = "testing-studio/testingstudio-api", version = "1.7.0" },
    { name = "diamant", version = "10.31.0" },
    { name = "hubot", version = "5.6.0" },
    { name = "ocp-console/console-ui/mfe-initializr", version = "0.1.1" },
    { name = "agi-connector", version = "4.10.1" },
    { name = "chat-connector", version = "8.5.1" },
    { name = "dashboard", version = "5.5.1" },
    { name = "envs-manager-api", version = "1.16.0" },
    { name = "deepasr", version = "7.8.1.0" },
    { name = "smr", version = "7.5.0.0" },
    { name = "nlu/operator", version = "1.1.3.2" },
    { name = "nlu-service-api", version = "1.3.0" },
    { name = "ml-nlu-service-api", version = "1.3.0" },
    { name = "nluengine-api", version = "7.0.0" },
    { name = "dataset-api", version = "1.4.0" },
    { name = "autocorrect-server", version = "3.0.0" },
    { name = "autocorrect-api", version = "1.3.0" },
    { name = "iam-api", version = "3.2.0" },
    { name = "idm-api", version = "3.2.0" },
    { name = "idm-energon", version = "3.2.0" },
    { name = "authz-sidecar", version = "1.3.0" },
    { name = "ocp-console/console-ui/mfe-server", version = "1.12.1" },
    { name = "ocp-console/console-api", version = "1.12.0" },
    { name = "ml-server", version = "3.2.2-ocp" },
    { name = "fusion-nlu-service-api", version = "1.3.0" },
    { name = "flume-storage-service-sink", version = "1.1.3" },
    { name = "orchestrator-api", version = "1.23.0" },
    { name = "miniapps-api", version = "3.14.0" },
    { name = "js-api", version = "1.5.0" },
    { name = "storage-service-api", version = "2.18.0" },
    { name = "exports-api", version = "1.6.0" },
    { name = "kafka-connect", version = "1.5.0-rc" },
    { name = "tts-proxy", version = "6.1.0" },
    { name = "encryption-service", version = "1.7.1" },
    { name = "dialogs-api", version = "2.1.0" },
    { name = "kamailio_omcti", version = "5.4.6.0-ssl-dyn" },
    { name = "omivr", version = "2.1.7" },
    { name = "ml-server", version = "ml-init-files-2.0.0" },
    { name = "kafka-connectors", version = "1.5.3-dev-feat-conan-1045-ebf0a588" },
    { name = "dialog-log-shipper", version = "1.0.0" }
  ]

  azure_artifacts = [
    { name = "miniapps-frontend-vue", version = "3.26.0", bucket = "ocp-stage-us-west-2-configurations" },
    { name = "ocp-nlu-xpacks", version = "1.3.0", bucket = "ocp-stage-us-west-2-nlu" }
  ]

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
    common_name         = "Omilia-FRM-Prod"
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
  cloudwatch_email_recipient = "systemengineering@nice.com"
  enable_cloudwatch_alarms   = true

  #======================
  # SIP
  #======================

  #eip_sip_count = 0

  prod_peers = ["twilio", "omilia_pbx", "prod"]

  kamailio_asg_desired_instance_size  = 3
  rtpengine_asg_desired_instance_size = 3

  certificate_name_crt = "ocp-prod/kamailio/cert"
  certificate_name_key = "ocp-prod/kamailio/cert_key"

  kamailio_ami_id  = "ami-06f555bf2f102b63c"
  rtpengine_ami_id = "ami-06f555bf2f102b63c"

  #======================
  # Custom options
  #======================
  standard_tags            = local.standard_tags
  deployment_principal_arn = "arn:aws:iam::730335349404:role/ServiceAccess-infrastructure-live-terraform"
  cluster_manage_aws_auth  = false
  disable_slack_webhook    = true

  # GitHub client credentials are expected to be as SSM params:
  #   - /common/argocd/github/client_id
  #   - /common/argocd/github/client_secret
  argocd_enable_github_login = true
  argocd_auth_policy         = "role:admin"
  argocd_github_access       = [
    {
      name  = "inContact"
      teams = [
        "kubernetes-admins",
        "systems-engineering"
      ]
    }
  ]

  # Additional Alert Manager topics
  alertmanager_topics = [
    "alertmanager"
  ]

  # SNS Funnel
  alarm_rename_rules = [
    {
      "pattern"  = ".*redis-node([0-9]+)-connections",
      "new_name" = "Omilia-FedRAMP-ocp-opensearch[AWS/ElastiCache=>CurrConnections]"
    },
    {
      "pattern"  = "Endpoint(.+)",
      "new_name" = "Omilia-FedRAMP-ocp-endpoints[AWS/EKS=>Endpoint=>\\1]"
    },
    {
      "pattern"  = ".+",
      "new_name" = "Omilia-FedRAMP-ocp-endpoints[None]"
    }
  ]

  # Target BMC accounts
  allowed_cross_account_subscriptions = [
    "751344753113" # ic-compliance-prod
  ]

  sns_funnel_variables = {
    ALARM_REGION_NAME = "US East (N. Virginia)"
  }

  # WAF
  use_waf                   = true
  waf_protected_paths_regex = "^\\/(argocd|monitoring)"
}
