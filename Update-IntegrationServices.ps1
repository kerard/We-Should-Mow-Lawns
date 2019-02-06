# Derived from https://forum.pulseway.com/topic/2075-update-hyper-v-integration-services/
# ANSI characters replaced with characters that actually work.

$vmtarget = Read-Host -Prompt 'Provide virtual machine name'

Get-VM -Name $vmtarget
 
Set-VMDvdDrive -VMName $vmtarget -Path "E:\vmguest.iso"

$DVDriveLetter = (Get-VMDvdDrive -VMName $vmtarget).Id | Split-Path -Leaf

Invoke-Command -ComputerName "$vmtarget.obie.local" -ScriptBlock {
		if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64")
			{
 				$folder = "amd64"
 			}
 		else
 			{
 				$folder = "x86" 
 			}
		$folder
			Start-Process -FilePath "$($using:DVDriveLetter):\support\$folder\setup.exe" -Args "/quiet /norestart" -Wait 
 	}