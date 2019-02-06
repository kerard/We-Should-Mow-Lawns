$defpassword = (ConvertTo-SecureString "Cinco123!" -AsPlainText -force)
$dnsroot = '@' + (Get-ADDomain).dnsroot
$users = Import-Csv BulkAddADUsers.csv

foreach ($user in $users) 
    {
        try {
            New-ADUser -SamAccountName $user.SamAccountName -Name ($user.FirstName + " " + $user.LastName) `
            -Path ($user.Path) `
            -DisplayName ($user.FirstName + " " + $user.LastName) -GivenName $user.FirstName -Surname $user.LastName `
            -EmailAddress ($user.SamAccountName + $dnsroot) -UserPrincipalName ($user.SamAccountName + $dnsroot) `
            -Description $user.Description `
            -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires  $true `
            -AccountPassword $defpassword -PassThru `
            }

        catch [System.Object] 
            {
            Write-Output "Could not create user $($user.SamAccountName), $_"
            }
        
        Add-ADGroupMember -Identity $user.InitialGroupMembership -Members $user.SamAccountName

    }

# Code block for creating super users in the domain.

$superpassword = (ConvertTo-SecureString "CoolRunnings123!" -AsPlainText -force)
$superusers = Import-Csv BulkAddADSuperUsers.csv

foreach ($superuser in $superusers) 
    {
        try {
            New-ADUser -SamAccountName $superuser.SamAccountName -Name ($superuser.FirstName + " " + $superuser.LastName) `
            -Path ($superuser.Path) `
            -DisplayName ($superuser.FirstName + " " + $superuser.LastName) -GivenName $superuser.FirstName -Surname $superuser.LastName `
            -EmailAddress ($superuser.SamAccountName + $dnsroot) -UserPrincipalName ($superuser.SamAccountName + $dnsroot) `
            -Description $superuser.Description `
            -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires  $true `
            -AccountPassword $superpassword -PassThru `
            }

        catch [System.Object] 
            {
            Write-Output "Could not create user $($superuser.SamAccountName), $_"
            }
        
        Add-ADGroupMember -Identity $superuser.InitialGroupMembership -Members $superuser.SamAccountName

    }

# Setup group membership for domain functional accounts
Add-ADGroupMember -Identity "Administrators" -Members domain.joiner
Add-ADGroupMember -Identity "Domain Admins" -Members domain.overlord
Add-ADGroupMember -Identity "Enterprise Admins" -Members domain.overlord
Add-ADGroupMember -Identity "Schema Admins" -Members domain.overlord