$serverlist = Get-Content ".\qliksense_startup.txt"
$wait = 150

filter timestamp {"$(Get-Date -Format G): $_"}

foreach ($server in $serverlist)
    {
        Write-Output "Starting $server and waiting 2.5 minutes for full startup." | timestamp
        
        Start-VM -VM $server -WhatIf
        
        sleep $wait
    }