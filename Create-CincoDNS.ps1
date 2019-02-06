Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools
Add-DnsServerPrimaryZone -Name "cinco.local" -ZoneFile "cinco.local.dns"
Add-DnsServerPrimaryZone -NetworkID 10.98.98.0/24 -ZoneFile "10.98.98.in-addr.arpa.dns"
Add-DnsServerForwarder -IPAddress 10.98.98.1 -PassThru