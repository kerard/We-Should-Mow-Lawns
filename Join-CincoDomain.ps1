$domain = 'cinco.local'; 
$userName = 'Administrator'; 
$password = 'Cinco123!' | ConvertTo-SecureString -AsPlainText -Force; 
$login = '{0}\{1}' -f $domain, $userName; 
$credential = New-Object System.Management.Automation.PSCredential($login, $password); 
Add-Computer -DomainName $domain -Credential $credential -Restart