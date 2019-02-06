filter timestamp {"It's Fucking $(Get-Date -Format G). Time To $_"}

$vm_data_disk_count = Read-Host "How many data disks would you like to create?"

For ($i=1; $i -le $vm_data_disk_count; $i++) 
    {
        Write-Output "Create Disk $i" | timestamp
        New-VHD -Path F:\hyperv\datadisk-$i.vhdx -SizeBytes 2GB -Fixed
    }