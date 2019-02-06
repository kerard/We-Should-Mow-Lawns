$nests = Import-Csv BulkNestADGroups.csv

foreach ($nest in $nests) 
    {
        Add-ADGroupMember -Identity $nest.Identity -Members $nest.Members
    }