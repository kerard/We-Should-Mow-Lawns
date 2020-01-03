$vmname = "AxisTV"
$vmtag = "VeeamReplication-AvigilonControlCenter"
$file = Get-Content 'C:\users\mw148186\OneDrive - The Andersons, Inc\just_nothing.txt'

# Simply view a list of tags assigned to VM.
foreach ( $line in $file )
   {
       Get-TagAssignment -Entity $line | ft -AutoSize
       # Get-TagAssignment -Entity $line -Category "Veeam-Replication" | Remove-TagAssignment
       # New-TagAssignment -Entity $line -Tag $vmtag
   }

# Get-TagAssignment -Entity $vmname -Category "Veeam-Replication" | ft -AutoSize

# Or, remove any tag in the "Veeam-Replication" category.
# Get-TagAssignment -Entity $vmname -Category "Veeam-Replication" | Remove-TagAssignment

# +++

# Apply new tag to VM.
# New-TagAssignment -Entity $vmname -Tag $vmtag

# Get a new list of tags assigned to VM (confirm tag assignment).
# Get-TagAssignment -Entity $vmname | ft -AutoSize