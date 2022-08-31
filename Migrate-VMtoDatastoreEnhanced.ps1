# generate a guid for this event, helps track unique things
$vmDeploymentEventGuid = [guid]::newguid()

# get creds
if (!($credential)) {$credential = get-credential}

# connect vsphere
connect-viserver -server 'vcenter.andent.andersonsinc.com' -credential $credential

# Create a text file containing a list of VMs and specify the path.
$vmList = Get-Content -Path "C:\Users\mw148186\OneDrive - The Andersons, Inc\Project - DR Tiering\Non-Production VMs.txt"

# Provide text pattern (Datastore Cluster name) to identify the target datastore.  Paste value from list between $targetDatastorePattern quotes.
# Possible values are...
# COB-PURE-DSC-RPO-01H
# COB-PURE-DSC-RPO-04H
# COB-PURE-DSC-RPO-08H
# COB-PURE-DSC-RPO-12H
# COB-PURE-DSC-RPO-24H
# COB-PURE-DSC-RPO-DNR
$targetDatastorePattern = "COB-PURE-DSC-RPO-DNR"

$targetDatastore = Get-DatastoreCluster -Name $targetDatastorePattern

foreach ($vm in $vmList)
{

Write-Host "Currently processing" $vm"..." -ForegroundColor Yellow

$currentDatastore = Get-VM -Name $vm | Get-Datastore

if ($currentDatastore -like $targetDatastorePattern + "*")
    {
        # If $currentDatastore is like $targetDatastore (based on $targetDatastorePattern), tell me the VM is on a new Pure DSC RPO datastore and the name of the datastore.
        Write-Host "$vm is already on datastore " -NoNewline; Write-Host $currentDatastore.Name -ForegroundColor Green -NoNewline; Write-Host ".  VM will not be migrated."
    }

    else 
    {
        # If not, tell me the VM will be moved from its current datastore to a new Pure DSC RPO datastore and tell me the name of the new datastore so I can visually verify.
        Write-Host "$vm is on datastore " -NoNewline; Write-Host $currentDatastore.Name -ForegroundColor Red -NoNewline; Write-Host " and will be migrated to " -NoNewline; Write-Host $targetDatastore.Name -ForegroundColor Blue
        # Move-VM -VM $vm -Datastore $targetDatastore
    }

}

# disconnect from vSphere
Disconnect-VIServer -Server 'vcenter.andent.andersonsinc.com' -Confirm:$false