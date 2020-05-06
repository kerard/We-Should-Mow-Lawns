# Save-Module -Name VMware.PowerCLI -Path C:\Users\mw148186_el\Documents\Powershell
# Install-Module -Name VMware.PowerCLI
Import-Module VMware.VimAutomation.PCloud

$VCServer = Read-Host 'Enter VC Server name'

$vcUSERNAME = Read-Host 'Enter user name'

$vcPassword = Read-Host 'Enter password' -AsSecureString

$vccredential = New-Object System.Management.Automation.PSCredential ($vcusername, $vcPassword)

Write-Host "Connecting to $VCServer..." -Foregroundcolor "Yellow" -NoNewLine

Connect-VIServer -Server $VCServer -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null

# Use the following statement to end your vCenter session.
# Get-PSSession | Remove-PSSession