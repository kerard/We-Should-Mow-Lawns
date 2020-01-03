$spreadsheet = Import-Csv -Path 'C:\users\mw148186\OneDrive - The Andersons, Inc\vm_on_error.csv'

# $outputfile = 'C:\users\mw148186\OneDrive - The Andersons, Inc\OUTPUT_Get-VeeamReplicationTagAssignment.txt'

foreach ( $line in $spreadsheet )
    {
        # The following line was used to generate a list of VMs with replication tags.
        # The code was written to verify the output intended for use in the pipelines.
        # Get-VM -Name $line.vm | % { Get-TagAssignment -Entity $_ | where { $_.Tag -like "Veeam-Replication*"}} | ft -AutoSize | Out-File $outputfile -Append

        
        # The following line retrieves tags from VMs specified in $spreadsheet that start with "Veeam-Replication" and removes the tag.
        Get-VM -Name $line.vm | % { Get-TagAssignment -Entity $_ | where { $_.Tag -like "Veeam-Replication*"} | Remove-TagAssignment -WhatIf }
        
        # The following line assigns tags to VMs specified in $spreadsheet.  Cardinality errors will be reported if the VM still has a replication tag.
        New-TagAssignment -Entity $line.vm -Tag $line.tag -WhatIf
    }