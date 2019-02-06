$SearchContainer = 'OU=Accounting,OU=Thanks Cinco,DC=cinco,DC=local'

$movetheseusers = Get-ADUser -Filter * -SearchBase $SearchContainer | Where-object { $_.UserPrincipalName -Match '^\w+\.' } | Select -ExpandProperty UserPrincipalName | Sort-Object -Property UserPrincipalName

$OUName = Get-ADOrganizationalUnit -Identity $SearchContainer

foreach ( $userprincipalname in $movetheseusers )
   {
       New-MoveRequest -Identity $userprincipalname -TargetDatabase $OUName.Name
   }