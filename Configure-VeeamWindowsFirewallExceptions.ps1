# Copy "Add-MvaNetFirewallRemoteAdressFilter.ps1" and "Configure-VeeamWindowsFirewallExceptions.ps1" to C:\toolbox

# Source "Add-MvaNetFirewallRemoteAdressFilter.ps1" as a module.
. C:\toolbox\Add-MvaNetFirewallRemoteAdressFilter.ps1

# Identify Windows Firewall rule names required for modification to facilitate Veeam traffic.
$firewallrulename = @("File Server Remote Management (DCOM-In)", "File and Printer Sharing (NB-Session-In)", "File and Printer Sharing (SMB-In)", "Distributed Transaction Coordinator (RPC)", "Distributed Transaction Coordinator (RPC-EPMAP)")

# Add the Veeam proxies to the rules defined in "$firewallrulename".
$firewallrulename | % { Get-NetFirewallrule -DisplayName $_ | Get-NetFirewallAddressFilter | Add-MvaNetFirewallRemoteAdressFilter -IPAddresses 10.0.0.120, 10.0.0.121 }