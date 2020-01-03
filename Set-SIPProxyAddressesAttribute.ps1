$content = Get-Content C:\Users\mw148186\Desktop\element_users_test.txt

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