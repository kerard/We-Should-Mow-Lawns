Get-ADUser -Filter * -SearchBase 'OU=Element,OU=Ethanol Group,OU=ANDE_Users,DC=andent,DC=andersonsinc,DC=com' -Properties DistinguishedName,proxyaddresses,targetAddress | Select name,targetAddress, @{L='UPPER_SMTP_ProxyAddresses' ; E={$_.proxyaddresses | Where-Object {$_ -clike 'SMTP:*'}}} , @{L='lower_smtp_ProxyAddresses' ; E={$_.proxyaddresses | Where-Object {$_ -clike 'smtp:*'}}} , @{L='SIP_ProxyAddresses' ; E={$_.proxyaddresses | Where-Object {$_ -clike 'SIP:*'}}} | Sort name | fl


$users = Import-Csv users.csv
#or
#$users = Get-ADUser -Filter * -SearchBase 'OU=Element,OU=Ethanol Group,OU=ANDE_Users,DC=andent,DC=andersonsinc,DC=com'

foreach ($user in $users) 
    {
    
    $sipProxy = (Get-ADUser $user -Properties ProxyAddresses).ProxyAddresses | ? { $_ -like "SIP:*" }
        
        foreach ($proxy in $sipProxy)
            {
                Set-ADUser $user -Remove @{ProxyAddresses=$proxy} -WhatIf
            }
    }