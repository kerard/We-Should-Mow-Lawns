#region Configure vDisks
If (!($oVM.HDD2Size) -eq '')) 
    {
        If (!($oVM.HDD2Format -eq '')) 
            {
                New-HardDisk -VM $oVM.Name -CapacityGB $oVM.HDD2Size
            }
        else
            {
                New-HardDisk -VM $oVM.Name -CapacityGB $oVM.HDD2Size -StorageFormat $oVM.HDD2Format
            }
    }

Controller
Datastore
DiskPath
