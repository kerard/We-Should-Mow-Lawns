Add-PSSnapin VeeamPSSnapin

Set-VBRViReplicaJob -Job <CBackupJob> `
    [-Name <string>] `
    # [-Server <Object>] `
    [-Entity <IViItem[]>] `
    # [-Datastore <VBRViDatastoreBase>] `
    # [-ResourcePool <CViResourcePoolItem>] `
    # [-Folder <CViFolderItem>] `
    # [-Suffix <string>] `
    # [-BackupRepository <CBackupRepository>] `
    # [-Description <string>] `
    # [-EnableNetworkMapping] `
    # [-SourceNetwork <VBRViNetworkInfo[]>] `
    # [-TargetNetwork <VBRViNetworkInfo[]>] `
    # [-SourceProxy <CViProxy[]>] `
    # [-TargetProxy <CViProxy[]>] `
    # [-UseWANAccelerator] `
    # [-SourceWANAccelerator <CWanAccelerator>] `
    # [-TargetWANAccelerator <CWanAccelerator>] `
    # [-RestorePointsToKeep <int>] `
    # [-ReplicateFromBackup] `
    # [-SourceRepository <CBackupRepository[]>] `
    # [-EnableReIp] `
    # [-ReIpRule <VBRViReplicaReIpRule[]>] `
    # [-DiskType <EDiskCreationMode> {Source | Thick | Thin | ThickEagerZeroed}] `
    # [-EnableSeeding] `
    # [-RepositorySeed <CBackupRepository>] `
    [# -EnableVMMapping] `
    # [-OriginalVM <CViVmItem[]>] `
    # [-ReplicaVM <CViVmItem[]>] `
    [-Force]  `
    # [<CommonParameters>]