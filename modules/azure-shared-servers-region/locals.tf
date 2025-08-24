locals {
  EnvVar_secrets_list = toset([
    "ad-base-ou-distinguished-name",
    "chef-environment-name",
    "chef-server-crt",
    "chef-server-name",
    "chef-validation-key",
    "cluster-internal-servers-nsg",
    "core-network-management-subnet",
    "core-network-core-subnet",
    "dmz-network-dmz-subnet",
    "domain-name",
    "network-logicmonitor-asg",
    "network-logicmonitor-nsg",
    "network-thousandeyesagentdmz-asg",
    "network-thousandeyesagentdmz-nsg",
    "network-thousandeyesagentinternal-asg",
    "network-thousandeyesagentinternal-nsg",
    "ng-bidatamart-asg",
    "ng-bidatamart-nsg",
    "ng-globalweb-asg",
    "ng-globalweb-nsg",
    "tools-bmcmonitoring-asg",
    "tools-bmcmonitoring-nsg",
    "tools-databasemonitor-asg",
    "tools-databasemonitor-nsg",
    "ng-globalweb-backend-pool",
  ])
  Systems_secrets_list = toset([
    "ad-domain-joiner-username",
    "ad-domain-joiner-password",
    "SystemsKeyPairPublicKeyOpenSSH",
  ])

  tags = merge(
    {
      CreatedBy           = "Terraform"
      TerraformModule     = "azure-shared-servers-region"
      ApplicationOwner    = "Systems Teams"
      InfrastructureOwner = "Systems Teams"
    },
    var.tags
  )

  vm_size_map = {
    "BIDatamart" = {
      "Prod" = "Standard_E4s_v5" # 4 vCPU / 32 GiB memory / 12.5 Gbps network / 350 (1200 burst) uncached Mbps disk
      # AWS: "r5.xlarge" # 4 vCPU / 32 GiB memory / up to 10 Gbps network / up to 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk / * Supports max 8 data disks (E2s_v5 only supports 4)
      # AWS: "r5.large" # 2 vCPU / 16 GiB memory / up to 10 Gbps network / up to 4,750 Mbps disk bandwidth
    }
    "BMCMonitoring" = {
      "Prod" = "Standard_D8s_v5" # 8 vCPU / 32 GiB memory / 12.5 Gbps network / 290 (1200 burst) uncached Mbps disk
      # AWS: "c5.2xlarge" # 8 vCPU / 16 GiB memory / up to 10 Gbps network / up to 4,750 Mbps disk bandwidth
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
    }
    "DatabaseMonitor" = {
      "Prod" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk
      # AWS: "m5.xlarge" # 4 vCPU / 16 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk      
    }
    "GlobalWeb" = {
      "Prod" = "Standard_D4s_v5" # 4 vCPU / 16 GiB memory / 12.5 Gbps network / 145 (1200 burst) uncached Mbps disk
      # AWS: "m5.xlarge" # 4 vCPU / 16 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
    }
    "LogicMonitor" = {
      "Prod" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "t3.medium" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "t3.medium" # 2 vCPU (24 burstable credits/hour) / 4 GiB memory
    }
    "ThousandEyesAgentDMZ" = {
      "Prod" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
    }
    "ThousandEyesAgentInternal" = {
      "Prod" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
      "PreProd" = "Standard_D2s_v5" # 2 vCPU / 8 GiB memory / 12.5 Gbps network / 85 (1200 burst) uncached Mbps disk
      # AWS: "m5.large" # 2 vCPU / 8 GiB memory / 10 Gbps network / up to 4,750 Mbps disk
    }
  }

  vm_image_map = {
    "BIDatamart" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
    "BMCMonitoring" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
    "DatabaseMonitor" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
    "GlobalWeb" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
    "LogicMonitor" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter"
      version   = "latest"
    }
    "ThousandEyesAgentDMZ" = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts-gen2"
      version   = "latest"
    }
    "ThousandEyesAgentInternal" = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts-gen2"
      version   = "latest"
    }
  }

  vm_disk_map = {
    "BIDatamart" = {
      "Apps" = {
        "Prod"       = "128" # Volume size 70 on AWS; consider 64 GB?
        "PreProd"    = "128"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
      "SQL_Data" = {
        "Prod"               = "4096" # Volume size 5120 on AWS; consider 4096 GB?
        "PreProd"            = "128"  # Volume size 80 on AWS
        drive_letter         = "E"
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 2
      }
      "SQL_Logs" = {
        "Prod"               = "512" # Volume size 350 on AWS
        "PreProd"            = "64"  # Volume size 60 on AWS
        drive_letter         = "L"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 3
      }
      "SQL_Tempdb" = {
        "Prod"               = "512" # Volume size 350 on AWS
        "PreProd"            = "64"  # Volume size 60 on AWS
        drive_letter         = "T"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 4
      }
      "SQL_Backup" = {
        "Prod"               = "1024"
        "PreProd"            = "64" # Volume size 60 on AWS
        drive_letter         = "S"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 5
      }
    }
    "BMCMonitoring" = {
      "Apps" = {
        "Prod"       = "128" # Volume size 70 on AWS; consider 64 GB?
        "PreProd"    = "128" # Volume size 70 on AWS; consider 64 GB?
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "DatabaseMonitor" = {
      "Apps" = {
        "Prod"       = "128" # Volume size 100 on AWS
        "PreProd"    = "128"
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
      "SQL_Data" = {
        "Prod"               = "4096" # Volume size 5120 on AWS; consider 4096 GB?
        "PreProd"            = "128"  # Volume size 80 on AWS
        drive_letter         = "E"
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 2
      }
      "SQL_Logs" = {
        "Prod"               = "512" # Volume size 350 on AWS
        "PreProd"            = "64"  # Volume size 60 on AWS
        drive_letter         = "L"   # Assumption; not specified in configure-disk-tools_databasemonitor.ps1
        allocation_unit_size = 65536
        caching              = "None"
        lun                  = 3
      }
      "SQL_Tempdb" = {
        "Prod"               = "512" # Volume size 350 on AWS
        "PreProd"            = "64"  # Volume size 60 on AWS
        drive_letter         = "T"   # Assumption; not specified in configure-disk-tools_databasemonitor.ps1
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 4
      }
      "SQL_Backup" = {
        "Prod"               = "1024"
        "PreProd"            = "64" # Volume size 60 on AWS
        drive_letter         = "F"
        allocation_unit_size = 65536
        caching              = "ReadOnly"
        lun                  = 5
      }
    }
    "GlobalWeb" = {
      "Apps" = {
        "Prod"       = "128" # Volume size 100 on AWS; consider 64 GB?
        "PreProd"    = "128" # No 'PreProd' on this server type in CloudFormation
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "LogicMonitor" = {
      "Apps" = {
        "Prod"       = "64" # Volume size 50 on AWS
        "PreProd"    = "64" # No 'PreProd' on this server type in CloudFormation
        drive_letter = "D"
        caching      = "ReadWrite"
        lun          = 1
      }
    }
    "ThousandEyesAgentDMZ"      = {}
    "ThousandEyesAgentInternal" = {}
  }

  data_disk_maps = {
    for tier in ["Prod", "PreProd"] : tier => {
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
