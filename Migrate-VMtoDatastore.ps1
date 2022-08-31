# connect-viserver -server 'vcenter.andent.andersonsinc.com'

$vmName = "DVCOBVTXWS01"

$myDatastoreCluster1 = Get-DatastoreCluster -Name 'COB-PURE-DSC-RPO-DNR'
Move-VM -VM $vmName -Datastore $myDatastoreCluster1