function Get-VHDStat {
    param(
    [Parameter(Mandatory=$false)]
    [string]
    $Cluster
    )
     
    if ($Cluster) {
        $VMs = Get-ClusterGroup -Cluster $cluster | where grouptype -eq 'virtualmachine' | Get-VM
    } else {
        $VMs = Get-VM
    }
        foreach ($VM in $VMs){
            $VHDs=Get-VHD $vm.harddrives.path -ComputerName $vm.computername
                foreach ($VHD in $VHDs) {
                    New-Object PSObject -Property @{
                        Name = $VM.name
                        Type = $VHD.VhdType
                        Path = $VHD.Path
                        Logical = $VHD.LogicalSectorSize
                        Physical = $VHD.PhysicalSectorSize
                        'Total' = [math]::Round($VHD.Size/1GB)
                        'Used' = [math]::Round($VHD.FileSize/1GB)
                        'Free' =  [math]::Round($VHD.Size/1GB- $VHD.FileSize/1GB)
                     }
                }
        }
    }