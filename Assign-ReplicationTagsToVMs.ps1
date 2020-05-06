# This script will retrieve a VM's currently assigned tag in vCenter and apply a new tag.
# The "if...then" logic handles VMs that do not have a tag assignment as this condition will create errors if not handled.
# Please observe the "-WhatIf" argument on all "set" logic.  Remove "-WhatIf" when desired results are observed and confirmed.
filter timestamp {"$(Get-Date -Format G): $_"}

# ECHO
Write-Output "Starting Work." | timestamp

# Create a comma delimited file with two columns: "Name" and "newtag".  Name it "input_vm_newtag.csv" and change the following path to the correct location.
$input_csv = Import-Csv -Path '.\input_vm_newtag.csv'

# GET and SET
foreach ( $line in $input_csv )
    {
        # GET
        # If the VM doesn't have a "Veeam-Replication..." tag assigned, tell me about it and then assign the new tag.
        if (!(Get-TagAssignment -Entity $line.Name -Category Veeam-Replication))
            {
                # ECHO
                Write-Host "No replication tag currently assigned to " -NoNewline; Write-Host $($line.Name) -ForegroundColor Red
                
                # SET
                New-TagAssignment -Entity $line.Name -Tag $line.newtag -Confirm:$false -WhatIf
                
                # ECHO
                Write-Host "Assigned " -NoNewline; Write-Host $($line.Name) -ForegroundColor Green -NoNewline; Write-Host " tag " -NoNewline; Write-Host $($line.newtag) -ForegroundColor Green
            }
        # If the VM does have a "Veeam-Replication..." tag assigned, get it so that it can be echoed to stdout, remove it, and then assign the new tag.
        else
            {
                # GET
                # Get the current tag assignment from vSphere so that it can be echoed to standard output.
                $tag = Get-TagAssignment -Entity $line.Name -Category Veeam-Replication
                
                # ECHO
                Write-Output "Getting current replication tag for $($tag.Entity.Name).  Current replication tag is $($tag.Tag.Name).  New replication tag should be $($line.newtag)"

                # SET
                # Remove the current tag assignment from the VM.
                Get-VM -Name $line.Name | Get-TagAssignment | ? { $_.tag -like "Veeam-Replication*"} | Remove-TagAssignment -Confirm:$false -WhatIf

                # SET
                # Assign a new tag as configured in the comma delimited file.
                New-TagAssignment -Entity $line.Name -Tag $line.newtag -Confirm:$false -WhatIf
            }
    }

# ECHO
Write-Output "Finished Work." | timestamp