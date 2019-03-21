$container = 'OU=DEF,OU=IT,OU=Privileged,OU=Cinco Corporation,DC=Cinco,DC=local'

Write-Host "Parsing $container.  Edit line 1 to parse a different container."

$userlist = Get-ADUser -Filter * -SearchBase $container | Where-object { $_.UserPrincipalName -Match '^\w+\.' } | Select-Object -ExpandProperty UserPrincipalName | Sort-Object -Property UserPrincipalName

foreach ( $user in $userlist )
	
    {
        		
        Get-MailboxStatistics $user | Format-Table DisplayName,TotalItemSize,ItemCount,Database
            
    }