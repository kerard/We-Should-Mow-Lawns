# connect-viserver -server 'vcenter.andent.andersonsinc.com'

$myDatastoreCluster1 = Get-DatastoreCluster -Name 'COB-PURE-DSC-RPO-DNR'
Move-VM -VM 'DVCOBLINUX02' -Datastore $myDatastoreCluster1