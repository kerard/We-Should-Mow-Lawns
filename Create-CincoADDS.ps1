Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest `
-InstallDns:$true `
-CreateDnsDelegation:$false `
-DomainName “cinco.local” `
-DatabasePath “C:\Windows\NTDS” `
-LogPath “C:\Windows\NTDS” `
-SysvolPath “C:\Windows\SYSVOL” `
-NoRebootOnCompletion:$false `
-Force:$true `
-DomainNetbiosName “CINCO” `
-ForestMode “Win2012R2” `
-DomainMode “Win2012R2”