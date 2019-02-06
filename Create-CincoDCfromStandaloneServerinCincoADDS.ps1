Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSDomainController `
-InstallDns:$true `
-CreateDnsDelegation:$false `
-DomainName “cinco.local” `
-DatabasePath “C:\Windows\NTDS” `
-LogPath “C:\Windows\NTDS” `
-SysvolPath “C:\Windows\SYSVOL” `
-NoRebootOnCompletion:$false `
-Force:$true `
-NoGlobalCatalog:$false `
-CriticalReplicationOnly:$false `
-SiteName "Default-First-Site-Name" `
-Credential (Get-Credential)