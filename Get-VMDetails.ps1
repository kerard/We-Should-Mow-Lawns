# $file = Get-Content 'C:\users\mw148186\OneDrive - The Andersons, Inc\just_nothing.txt'
$file = Import-Csv 'C:\users\mw148186\OneDrive - The Andersons, Inc\ExportList.csv'
$output = 'C:\users\mw148186\OneDrive - The Andersons, Inc\theoutput.txt'

foreach ( $line in $file )
    {
        Get-VM -Name $line.Name | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Folder";E={$_.Folder.Name}} | ft -AutoSize | Out-File $output -Append
        Get-TagAssignment -Entity $line.Name | ft -AutoSize | Out-File $output -Append
    }