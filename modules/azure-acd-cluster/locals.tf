locals {
  EnvVar_secrets_list = toset([
    "ad-base-ou-name",
    "ad-base-ou-distinguished-name",
    "chef-environment-name",
    "chef-server-crt",
    "chef-server-name",
    "chef-validation-key",
    "cluster-dmz-servers-asg",
    "cluster-dmz-servers-nsg",
    "cluster-internal-servers-asg",
    "cluster-internal-servers-nsg",
    "core-network-core-subnet",
    "core-network-serverless-subnet",
    "dmz-network-dmz-subnet",
    "domain-name",
    "ng-api-backend-pool",
    # "ng-globalweb-backend-pool",
    "ng-web-backend-pool",
    #"storageservices-migration-backend-pool",
  ])
  Systems_secrets_list = toset([
    "ad-domain-joiner-username",
    "ad-domain-joiner-password"
  ])

  tags = merge(
    {
      CreatedBy           = "Terraform"
      TerraformModule     = "azure-acd-cluster"
      ApplicationOwner    = "Systems Teams"
      InfrastructureOwner = "Systems Teams"
      Product             = "ACD"
      Cluster             = upper(var.cluster_id)
    },
    var.tags
  )

  vm_size_map = {
    "API" = {
      "Prod" = "Standard_D8s_v5" # 8 vCPU / 32 GiB memory / 12.5 Gbps network / 290 (1200 burst) uncached Mbps disk
      # AWS: "m5.2xlarge" # 8 vCPU / 32 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "Dev" = "Standard_B2s" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
      # AWS: "t3.micro" # 2 vCPU (12 burstable credits/hour) / 1 GiB memory
    }
    "BITube" = {
      "Prod" = "Standard_E16s_v5" # 16 vCPU / 128 GiB memory / 12.5 Gpbs network / 600 (1200 burst) uncached Mbps disk
      # AWS: "x1e.xlarge" # 4 vCPU / 122 GiB memory / up to 10 Gbps network / 120 GB local SSD / 500 Mbps dedicated disk bandwidth
      "PreProd" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk / * Supports max 8 data disks (E2s_v5 only supports 4)
      # AWS: "r5.large" # 2 vCPU / 16 GiB memory / up to 10 Gbps network / up to 4,750 Mbps disk bandwidth
      "Dev" = "Standard_B4ms" # 4 vCPU (54 burstable credits/hour) / 16 GiB memory / * Supports max 8 data disks (B2ms only supports 4)
      # AWS: "t3.large" # 2 vCPU (36 burstable credits/hour) / 8 GiB memory
    }
    "Core" = {
      "Prod" = "Standard_D16s_v5" # 16 vCPU / 64 GiB memory / 12.5 Gbps network / 600 (1200 burst) uncached Mbps disk
      # Alternate: "Standard_L16s_v3" # 16 vCPU / 128 GiB memory / 12.5 Gbps network / 600 (1600 burst) uncached Mbps disk / NVMe 4 Gbps disk throughput
      # AWS: "m5.4xlarge" # 16 vCPU / 64 GiB memory / 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk / * Supports 8 max data disks (D2s_v5 only supports 4)
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "Dev" = "Standard_B4ms" # 4 vCPU (54 burstable credits/hour) / 16 GiB memory / * Supports max 8 data disks (B2ms only supports 4)
      # AWS: "t3.large" # 2 vCPU (36 burstable credits/hour) / 8 GiB memory
    }
    "DataWarehouse" = {
      "Prod" = "Standard_E8s_v5" # 8 vCPU / 64 GiB memory / 12.5 Gbps network / 290 (1200 burst) uncached Mbps disk
      # AWS: "r5.2xlarge" # 8 vCPU / 64 GiB memory / up to 10 Gbps network / up to 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk / * Supports max 8 data disks (E2s_v5 only supports 4)
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "Dev" = "Standard_B4ms" # 4 vCPU (54 burstable credits/hour) / 16 GiB memory / * Supports max 8 data disks (B2ms only supports 4)
      # AWS: "t3.large" # 2 vCPU (36 burstable credits/hour) / 8 GiB memory
    }
    "Media" = {
      "PreProd" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk
      # AWS: "c5.xlarge" # 4 vCPU / 8 GiB memory / up to 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "c5.large" # 2 vCPU / 4 GiB memory / up to 4,750 Mbps disk bandwidth
      "Dev" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "c5.large" # 2 vCPU / 4 GiB memory / up to 4,750 Mbps disk bandwidth
    }
    "StorageMigration" = {
      "Prod" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "c5.large" # 2 vCPU / 4 GiB memory / up to 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "t2.medium" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
      "Dev" = "Standard_B2s" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
      # AWS: "t3.medium" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
    }
    "Web" = {
      "Prod" = "Standard_D8s_v5" # 8 vCPU / 32 GiB memory / 12.5 Gbps network / 290 (1200 burst) uncached Mbps disk
      # AWS: "m5.2xlarge" # 8 vCPU / 32 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "Dev" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
    }
  }

  vm_disk_map = {
    "API" = {
      "Apps" = {
        "Prod"       = "256" # AppsVolume size 200 GB on AWS
        "PreProd"    = "256"
        "Dev"        = "256"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "BITube" = {
      "Apps" = {
        "Prod"       = "128" # Volume size 70 on AWS; consider 64 GB?
        "PreProd"    = "128"
        "Dev"        = "128"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
      "SQL_Data" = {
        "Prod"               = "64"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "E"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 2
      }
      "SQL_Analysis_Services" = {
        "Prod"               = "128"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "F"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 3
      }
      "SQL_Logs" = {
        "Prod"               = "64"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "L"
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 4
      }
      "SQL_Tempdb" = {
        "Prod"               = "64"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "T"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 5
      }
      "SQL_Backup" = {
        "Prod"               = "256"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "S"
        allocation_unit_size = 65536
        caching              = "ReadWrite"
        lun                  = 6
      }
    }
    "Core" = {
      "Apps" = {
        "Prod"       = "256" # AppsVolume size 200 GB on AWS
        "PreProd"    = "256"
        "Dev"        = "256"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
      "SQL_Data" = {
        "Prod"               = "512"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "E"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 2
      }
      "SQL_Logs" = {
        "Prod"               = "128"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "L"
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 3
      }
      "FS3" = {
        "Prod"       = "2048"
        "PreProd"    = "128"
        "Dev"        = "32"
        drive_letter = "R"
        caching      = "ReadWrite"
        lun          = 4
      }
      "SQL_Backup" = {
        "Prod"               = "512"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "F"
        allocation_unit_size = 65536
        caching              = "ReadWrite"
        lun                  = 5
      }
      "SQL_Tempdb" = {
        "Prod"               = "70"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "T"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 6
      }
    }
    "DataWarehouse" = {
      "Apps" = {
        "Prod"       = "128" # AppsVolume size 100 GB on AWS
        "PreProd"    = "128"
        "Dev"        = "128"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
      "SQL_Logs" = {
        "Prod"               = "128"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "L"
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 2
      }
      "SQL_Tempdb" = {
        "Prod"               = "128"
        "PreProd"            = "32"
        "Dev"                = "32"
        drive_letter         = "T"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 3
      }
      "SQL_Data" = {
        "Prod"               = "1024"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "R"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 4
      }
      "SQL_Backup" = {
        "Prod"               = "256"
        "PreProd"            = "64"
        "Dev"                = "32"
        drive_letter         = "S"
        allocation_unit_size = 65536
        caching              = "ReadWrite"
        lun                  = 5
      }
    }
    "Media" = {
      "Apps" = {
        "Prod"       = "128" # 100 GB on AWS
        "PreProd"    = "64"  # 40 GB on AWS
        "Dev"        = "32"  # 20 GB on AWS
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "StorageMigration" = {
      "Apps" = {
        "Prod"       = "64" # AppsVolume size 40 GB on AWS; consider 32 GB?
        "PreProd"    = "64"
        "Dev"        = "64"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "Web" = {
      "Apps" = {
        "Prod"       = "128" # AppsVolume size 100 GB on AWS
        "PreProd"    = "128"
        "Dev"        = "128"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
  }

  data_disk_maps = {
    for tier in ["Prod", "PreProd", "Dev"] : tier => {
      for type, disks in local.vm_disk_map : type => {
        for disk, settings in disks : disk => {
          storage_account_type = lookup(settings, "storage_account_type", "Premium_LRS")
          create_option        = lookup(settings, "create_option", "Empty")
          disk_size_gb         = settings["${tier}"]
          allocation_unit_size = lookup(settings, "allocation_unit_size", "4096")
          drive_letter         = settings.drive_letter
          caching              = settings.caching
          lun                  = settings.lun
        }
      }
    }
  }
}
