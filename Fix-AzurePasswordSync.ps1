$adConnector = "Keller.local"
$aadConnector = "kellerlogistics1.onmicrosoft.com - AAD"

Import-Module adsync

$c = Get-ADSyncConnector -Name $adConnector

$p = New-Object Microsoft.IdentityManagement.PowerShell.ObjectModel.ConfigurationParameter "Microsoft.Synchronize.ForceFullPasswordSync", String, ConnectorGlobal, $null, $null, $null

$p.Value = 1

$c.GlobalParameters.Remove($p.Name)

$c.GlobalParameters.Add($p)

$c = Add-ADSyncConnector -Connector $c

Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $false

Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $true