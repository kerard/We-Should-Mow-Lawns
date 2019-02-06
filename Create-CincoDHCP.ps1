Install-WindowsFeature -Name DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-service dhcpserver
Add-DhcpServerInDC -DnsName ws1.cinco.local -IPAddress 10.98.98.10
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2
Set-DhcpServerv4DnsSetting -ComputerName "ws1.cinco.local" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
$Credential = Get-Credential
Set-DhcpServerDnsCredential -Credential $Credential -ComputerName "ws1.cinco.local"
Add-DhcpServerv4Scope -name "Cinco Subnet" -StartRange 10.98.98.100 -EndRange 10.98.98.200 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -OptionID 3 -Value 10.98.98.1 -ScopeID 10.98.98.0 -ComputerName ws1.cinco.local
Set-DhcpServerv4OptionValue -DnsDomain cinco.local -DnsServer 10.98.98.10