# Derived from https://community.idera.com/database-tools/powershell/ask_the_experts/f/active_directory__powershell_remoting-9/20598/pull-out-smtp-addresses-for-each-user-object

Get-ADUser -Filter * -SearchBase 'OU=NewAccounts,OU=ANDE_Users,DC=andent,DC=andersonsinc,DC=com' -Properties proxyaddresses | Select-Object Name, @{ L = "ProxyAddresses"; E = { $_.ProxyAddresses -join ";" | Where-Object { ProxyAddresses -eq "*smtp:*" } } } | Export-Csv -Path "<Path>" –NoTypeInformation


Get-ADUser -Identity JU140003 -SearchBase 'OU=NewAccounts,OU=ANDE_Users,DC=andent,DC=andersonsinc,DC=com' -Properties ProxyAddresses | Select-Object Name,ProxyAddresses,SamAccountName,UserPrincipalName | ft

Get-ADuser -filter * -Properties  msExchRemoteRecipientType | Select-Object name, msExchRemoteRecipientType | where {$_.msExchRemoteRecipientType -eq 4}

-filter 'Name -like "*SvcAccount"'

Get-ADuser -Identity JU140003 -Properties  msExchRemoteRecipientType | Select-Object name, msExchRemoteRecipientType, msExchRecipientDisplayType, msExchRecipientTypeDetails

Get-ADuser -Identity JU140003 -Properties  * | Select-Object Name, msExchRemoteRecipientType, msExchRecipientDisplayType, msExchRecipientTypeDetails

$dummydata = @('Bill','Joe','Sam')

$filter = [scriptblock]::create(($dummydata| foreach {"(GivenName -eq '$_')"}) -join ' -or ')
Get-ADUser -f $filter


Remove-MsolUser -ObjectId dcd00102-9dc3-4367-9797-e238a1863dd1 -RemoveFromRecycleBin 

Get-MsolUser -ReturnDeletedUsers -UserPrincipalName Megan_Siefker@andersonsinc.com | select firstname,objectid