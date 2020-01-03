$file = Get-Content 'C:\users\mw148186\OneDrive - The Andersons, Inc\just_nothing.txt'
# $file = Import-Csv 'C:\users\mw148186\OneDrive - The Andersons, Inc\ExportList.csv'
$output = 'C:\users\mw148186\OneDrive - The Andersons, Inc\theoutput.txt'

foreach ( $line in $file )
    {
        $replicationtag = Get-TagAssignment -Entity $line -Category "Veeam-Replication"
        Get-VM -Name $line | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Folder";E={$_.Folder.Name}},@{N="Replication Tag";E={$replicationtag.Tag}} | ft -AutoSize
    }