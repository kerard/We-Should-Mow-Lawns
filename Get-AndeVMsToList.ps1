# New-TagAssignment -Entity AxisTV -Tag 

# get-datacenter -name "us-oh-maumee-cob" | get-folder -name 'some name' | get-vm | % {$_.name} | out-file -append "C:\users\mw148186\OneDrive - The Andersons, Inc\somepath.txt"

Get-Datacenter -Name "US-OH-Maumee-COB" | Get-Folder -Name 'Infrastructure' | Get-VM | % {$_.Name} | Out-File -Append 'C:\users\mw148186\OneDrive - The Andersons, Inc\vmlist-output.txt'

Get-Datacenter -Name "US-OH-Maumee-COB" | Get-Folder -Name 'Infrastructure' | Get-VM | % {$_.Name} | Sort | Out-File -Append 'C:\users\mw148186\OneDrive - The Andersons, Inc\vmlist-output.txt'

Get-Datacenter -Name "US-OH-Maumee-COB" | Get-Folder -Name 'Citrix Virtual Apps and Desktops 18.11' | Get-VM | % {$_.Name} | Sort

Get-TagAssignment -Category Veeam-Replication | ft -AutoSize

Get-TagAssignment -Entity PRCOBCTXFAS01 | ft -AutoSize


Get-Datacenter -Name 'US-OH-Maumee-COB' | Get-Folder -Name 'Citrix Virtual Apps and Desktops 18.11' | Get-VM | % {Get-TagAssignment -Entity $_.Name} | Sort Entity | ft -AutoSize

Get-Datacenter -Name "US-OH-Maumee-COB" | Get-Folder -Name 'Citrix Virtual Apps and Desktops 19.03' | Get-VM | where {$_.Name -inotlike "DV*"} | Sort Name | ft -AutoSize