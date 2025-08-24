# Disk Initialization Desired State Configuration Documentation

## Modules
* [StorageDsc](https://github.com/dsccommunity/StorageDsc/wiki/)
* [cMoveAzureTempDrive](https://www.powershellgallery.com/packages/cMoveAzureTempDrive/1.0.1)

## Running DSC Locally
1. Dot source the configuration script: `. .\DiskInitialization.ps1`
2. Build the MOF files by running the configuration (similar to function): `DiskInitialization`
    * This will create a new directory named DiskInitialization and build the MOF files
3. Start the DSC Configuration (pass directory containing MOFs): `Start-DSCConfiguration .\DiskInitialization`
4. Review with `Get-DSCConfiguration` and/or `Get-Job -id <job_id> | Receive-Job`

## Update DiskInitialization zip
1. `Install-Module Azure`
2. `Publish-AzureVMDscConfiguration .\DiskInitialization.ps1 -ConfigurationArchivePath DiskInitialization.zip`
    * Unfortunately using this "Publish_AzureVMDscConfiguration" cmdlet to generate the archive is necessary for the DSC VM extension to work properly. Although it seems like it should be easy to zip up all the same files, it doesn't work.
3. Upload DiskInitialization.zip to storage account (overwrite exisiting file) in each environment/subscription