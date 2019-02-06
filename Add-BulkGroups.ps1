$groups = Import-Csv BulkAddADGroups.csv

foreach ($group in $groups)
    {
        New-ADGroup -Name $group.Name -SamAccountName $group.Name -GroupCategory Security -GroupScope Global -DisplayName $group.Name -Path $group.Path -Description $group.Description
    }