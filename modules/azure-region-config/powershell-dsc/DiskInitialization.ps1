Configuration DiskInitialization 
{
  param
  (
    [string]
    $disk_list,

    [string]
    $computer_name = $ENV:COMPUTERNAME
  )

  Import-DSCResource -ModuleName StorageDsc
  Import-DSCResource -ModuleName cMoveAzureTempDrive

  $json = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($disk_list))
  $disks = ConvertFrom-Json $json
  
  # Determine if temp drive / optical drive exists
  $temp_drive = Get-WmiObject -Class win32_volume -Filter 'Label = "Temporary Storage"'
  $optical_drive = Get-CimInstance -ClassName Win32_CDROMDrive | Where-Object -FilterScript {-not ($_.Caption -eq 'Microsoft Virtual DVD-ROM' -and ($_.DeviceID.Split('\')[-1]).Length -gt 10)}  
  
  Node localhost
  {
    if($optical_drive)
    {
      OpticalDiskDriveLetter SetOpticalDiskDriveLetterToY
      {
        DiskId      = 1
        DriveLetter = 'Y'
      }
    }

    if($temp_drive)
    {
      cMoveAzureTempDrive SetAzureTempDriveLetterToZ
      {
        Name            = $computer_name
        TempDriveLetter = 'Z'
      }
    }

    foreach ($disk in $disks)
    {
      WaitForDisk $disk.label
      {
        DiskId           = (Get-Disk | Where-Object { $_.UniqueId -in $(Get-PhysicalDisk | Select-Object -ExpandProperty UniqueId) -and $_.Location -Match "LUN $($disk.LUN)" } | Select-Object -ExpandProperty UniqueId)
        DiskIdType       = "UniqueId"
        RetryIntervalSec = 30
        RetryCount       = 10
      }

      Disk $disk.label
      {
        DiskId             = (Get-Disk | Where-Object { $_.UniqueId -in $(Get-PhysicalDisk | Select-Object -ExpandProperty UniqueId) -and $_.Location -Match "LUN $($disk.LUN)" } | Select-Object -ExpandProperty UniqueId)
        DiskIdType         = "UniqueId"
        PartitionStyle     = "GPT"
        DriveLetter        = $disk.letter
        FSLabel            = $disk.label
        FSFormat           = "NTFS"
        AllocationUnitSize = $disk.AUSize
        AllowDestructive   = $true
        DependsOn          = "[WaitForDisk]$($disk.label)"
      }
    }

    Disk RelabelOSDrive
    {
        DiskId           = 0
        DiskIdType       = "Number"
        PartitionStyle   = "MBR"
        DriveLetter      = "C"
        FSLabel          = "OS"
        AllowDestructive = $false
    }
  }
} 
