# Create Powershell filter called "timestamp" to echo date and time as the script executes.
filter timestamp {"$(Get-Date -Format G). $_"}

#####################################
# Begin variable declaration block. #
#####################################

# Setup VM parameters

Write-Output "Setup VM Parameters." | timestamp

# Prompt for VM name from user.

$vm_name = Read-Host "Please provide a name for the new virtual machine"

# Prompt for VM VLAN from user.

$vm_vlan_id = Read-Host "Please provide a VLAN for the new virtual machine"

# Specify the amount of virtual CPU cores for the VM.

$vm_processor_count = Read-Host "Please provide amount of CPU cores for the new virtual machine"

# Specify the amount of virtual RAM for the VM.

$vm_ram = 2GB

# Specify the generation of the VM.

$vm_generation = "2"

# Specify the Hyper-V switch used by the VM.
# Use Get-VMSwitch on the Hyper-V host to retrieve a list of virtual switches.

$vm_switchname = "InternalSwitch"

# Specify the top-level directory for storing the VM.
# The VM will be stored in a subfolder within the path specified.

$vm_path = "F:\hyperv"

# Specify the location of your "golden image" virtual hard disk.

$source_boot_vhdx = "C:\Users\sandbox\Documents\library\template_gui.vhdx"

# Specify the location of your Hyper-V Guest Additions disk.
# This removes a step if you need to install Guest Additions after the VM comes online.

$hyperv_integration_disk = "C:\Users\sandbox\Documents\library\vmguest.iso"

# There is no need to change the $vm_copy_path_dest value.
# This variable creates a full path to the VM folder that can be used as a destination for copying files.

$vm_copy_path_dest = "$vm_path\$vm_name"

###################################
# End variable declaration block. #
###################################

##########################
# Begin execution block. #
##########################

Write-Output "Creating the VM." | timestamp

New-VM -Name $vm_name -MemoryStartupBytes $vm_ram -Generation $vm_generation -Path $vm_path -SwitchName $vm_switchname

Write-Output "VM Created.  Configuring..." | timestamp

Set-VMProcessor -VMName $vm_name -Count $vm_processor_count

# REM'd for sandbox server.  No VLAN information needed.
# Set-VMNetworkAdapterVlan -VMName $vm_name -Access -VlanId $vm_vlan_id

# Copy the boot disk

Write-Output "Copy the boot disk." | timestamp

Start-Sleep 15

Copy-Item $source_boot_vhdx $vm_copy_path_dest\$vm_name-boot.vhdx

# Attach the boot disk to the VM

Write-Output "Attach the boot disk to the VM." | timestamp

Get-VM -VMName $vm_name | Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -Path $vm_copy_path_dest\$vm_name-boot.vhdx

# Add an optical drive and mount the Integration disk

Write-Output "Add an optical drive and mount the Integration disk." | timestamp

Get-VM -VMName $vm_name | Add-VMDvdDrive -ControllerNumber 0 -Path $hyperv_integration_disk

# The following two lines (New-VHD and Add-VMHardDiskDrive) can be used to add additional storage to the VM.
#
# They remain commented out by default.
#
# New-VHD -Path "$vm_copy_path_dest\$vm_name-datavol.vhdx" -SizeBytes 100GB -Fixed
#
# Get-VM -VMName "$vm_name" | Add-VMHardDiskDrive -ControllerType SCSI -ControllerNumber 0 -Path "$vm_copy_path_dest\$vm_name-datavol.vhdx"

# Set boot drive order

Write-Output "Set boot drive order." | timestamp

$vmHardDiskDrive = Get-VMHardDiskDrive -VMName $vm_name -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0

Set-VMFirmware -VMName $vm_name -FirstBootDevice $vmHardDiskDrive

########################
# End execution block. #
########################