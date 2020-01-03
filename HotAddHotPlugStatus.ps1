#*************************************************************************************************************
#      Script Name	:   HotAddHotPlugStatus.ps1
#      Purpose		:   Get the report of Hot Add / Hot Plug Status of the VMS
#      Date		:   10-03-2017	# - Initial version
#                   	:  
#      Author		:   www.vmwarearena.com	
#
#*************************************************************************************************************
#
#Import-Module VMware.VimAutomation.Core
Import-Module VMware.VimAutomation.PCloud
$VCServer = Read-Host 'Enter VC Server name'
$vcUSERNAME = Read-Host 'Enter user name'
$vcPassword = Read-Host 'Enter password' -AsSecureString
$vccredential = New-Object System.Management.Automation.PSCredential ($vcusername, $vcPassword)

$LogFile = "VMHotAddHotPlugStatus_" + (Get-Date -UFormat "%d-%b-%Y-%H-%M") + ".csv" 

Write-Host "Connecting to $VCServer..." -Foregroundcolor "Yellow" -NoNewLine
$connection = Connect-VIServer -Server $VCServer -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null
$Result = @()

If($? -Eq $True)

{
	Write-Host "Connected" -Foregroundcolor "Green" 
	Write-Host "Collecting Hot Plug Status of the VMS ..." -Foregroundcolor "Yellow" -NoNewLine
	$Results = @()
	$Result = (Get-VM | select ExtensionData).ExtensionData.config | Select Name, MemoryHotAddEnabled, CpuHotAddEnabled, CpuHotRemoveEnabled
	$Result | Export-Csv -NoTypeInformation $LogFile
	Write-Host "Completed" -Foregroundcolor "Green"
}
Else
{
	Write-Host "Error in Connecting to $VIServer; Try Again with correct user name & password!" -Foregroundcolor "Red" 
}
Disconnect-VIServer * -Confirm:$false
#
#-------------------------------------------------------------------------------------------------------------