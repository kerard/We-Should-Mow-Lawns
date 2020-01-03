# New-Tag -Name VeeamReplication-AvigilonControlCenter -Category Veeam-Replication -Description "This is a test tag"

$file = Get-Content 'C:\users\mw148186\OneDrive - The Andersons, Inc\TAGS-CHANGE-VeeamReplication-COB-Infrastructure.txt'

foreach ($line in $file)
    {
        New-Tag -Name $line -Category Veeam-Replication
    }