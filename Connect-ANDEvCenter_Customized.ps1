Import-Module VMware.VimAutomation.PCloud

# VCENTER.ANDENT.ANDERSONSINC.COM
# $VCServer = Read-Host 'Enter VC Server name'
$VCServer = "VCENTER.ANDENT.ANDERSONSINC.COM"

# mw148186_el
# $vcUSERNAME = Read-Host 'Enter user name'
$vcUSERNAME = "mw148186_el"

$vcPassword = Read-Host 'Enter password' -AsSecureString

$vccredential = New-Object System.Management.Automation.PSCredential ($vcusername, $vcPassword)

Write-Host "Connecting to $VCServer..." -Foregroundcolor "Yellow" -NoNewLine

$connection = Connect-VIServer -Server $VCServer -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null

# Get-PSSession | Remove-PSSession