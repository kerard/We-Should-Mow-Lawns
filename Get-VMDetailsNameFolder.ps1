﻿# $file = Get-Content 'C:\users\mw148186\OneDrive - The Andersons, Inc\just_nothing.txt'
# $file = Import-Csv 'C:\users\mw148186\OneDrive - The Andersons, Inc\ExportList.csv'
$file = Get-DatastoreCluster -Name HQ-IBM-V7000-GP-SDRS-PRD | Get-Datastore | Where-Object { $_ -like '*-06*' } | Get-Vm | Sort-Object
$output = 'C:\users\mw148186\OneDrive - The Andersons, Inc\HQ-IBM-V7000-GP-VMFS-PRD-06.txt'
$arraylist = New-Object System.Collections.Arraylist

foreach ( $line in $file )
    {
        # Get-VM -Name $line.Name | Select Name,@{N="Folder";E={$_.Folder.Name}},@{N="Replication Tag";E={Get-TagAssignment -Entity $_.Name -Category "Veeam-Replication"}} | ft -AutoSize
        $replicationtag = Get-TagAssignment -Entity $line.Name -Category "Veeam-Replication"
        $arraylist.add($(Get-VM -Name $line.Name | Select-Object Name,@{N="Folder";E={$_.Folder.Name}},@{N="Replication Tag";E={$replicationtag.Tag}})) | Out-null
    }

$arraylist | Tee-Object -FilePath $output