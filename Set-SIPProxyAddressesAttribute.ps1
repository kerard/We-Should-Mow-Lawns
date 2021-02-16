$content = Get-Content C:\toolbox\file.txt

foreach ($user in $content)
    {
        $shortname = Get-ADUser -f {name -like $user} | select SamAccountName,UserPrincipalName

        $sipProxy = (Get-ADUser $shortname.SamAccountName -Properties ProxyAddresses).ProxyAddresses | ? { $_ -like "SIP:*" }

        $shortname

        $sipProxy

        Set-ADUser $shortname.SamAccountName -Remove @{ProxyAddresses=$sipProxy}

        $newsipaddress = 'SIP:' + $shortname.UserPrincipalName
        
        Set-ADUser $shortname.SamAccountName -Add @{ProxyAddresses=$newsipaddress}
        
        $newshortname = Get-ADUser -f {name -like $user} | select SamAccountName,UserPrincipalName

        $newsipProxy = (Get-ADUser $shortname.SamAccountName -Properties ProxyAddresses).ProxyAddresses | ? { $_ -like "SIP:*" }

        $newshortname

        $newsipProxy      
    }