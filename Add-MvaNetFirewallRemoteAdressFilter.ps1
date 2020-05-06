function Add-MvaNetFirewallRemoteAdressFilter {
    <#
.SYNOPSIS
This function adds one or more ipaddresses to the firewall remote address filter
.DESCRIPTION
With the default Set-NetFirewallAddressFilter you can set an address filter for a firewall rule. You can not use it to
add a ip address to an existing address filter. The existing address filter will be replaced by the new one.
The Add-MvaNetFirewallRemoteAdressFilter function will add the ip address. Which is very usefull when there are already
many ip addresses in de address filter.
.PARAMETER fwAddressFilter
This parameter conntains the AddressFilter that you want to change. It accepts pipeline output from the command
Get-NetFirewallAddressFilter
.PARAMETER IPaddresses
This parameter is mandatory and can contain one or more ip addresses. You can also use a subnet.
.EXAMPLE
Get-NetFirewallrule -DisplayName 'Test-Rule' | Get-NetFirewallAddressFilter | Add-MvaNetFirewallRemoteAdressFilter -IPAddresses 192.168.5.5
Add a single IP address to the remote address filter of the firewall rule 'Test-Rule'
.EXAMPLE
Get-NetFirewallrule -DisplayName 'Test-Rule' | Get-NetFirewallAddressFilter | Add-MvaNetFirewallRemoteAdressFilter -IPAddresses 192.168.5.5, 192.168.6.6, 192.168.7.0/24
Add multiple IP address to the remote address filter of the firewall rule 'Test-Rule'
.LINK
https://get-note.net/2018/12/31/edit-firewall-rule-scope-with-powershell/
.INPUTS
Microsoft.Management.Infrastructure.CimInstance#root/standardcimv2/MSFT_NetAddressFilter
.OUTPUTS
None
.NOTES
You need to be Administator to manage the firewall.
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true,
            Mandatory = $True)]
        [psobject]$fwAddressFilter,

        # Parameter help description
        [Parameter(Position = 0,
            Mandatory = $True,
            HelpMessage = "Enter one or more IP Addresses.")]
        [string[]]$IPAddresses
    )

    process {
        try {
            #Get the current list of remote addresses
            [string[]]$remoteAddresses = $fwAddressFilter.RemoteAddress
            Write-Verbose -Message "Current address filter contains: $remoteAddresses"

            #Add new ip address to the current list
            if ($remoteAddresses -in 'Any', 'LocalSubnet', 'LocalSubnet6', 'PlayToDevice') {
                $remoteAddresses = $IPAddresses
            }
            else {
                $remoteAddresses += $IPAddresses
            }
            #set new address filter
            $fwAddressFilter | Set-NetFirewallAddressFilter -RemoteAddress $remoteAddresses -ErrorAction Stop
            Write-Verbose -Message "New remote address filter is set to: $remoteAddresses"
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}