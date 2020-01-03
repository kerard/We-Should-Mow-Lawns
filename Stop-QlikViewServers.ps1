$serverlist = Get-Content ".\qlikview_shutdown.txt"
$wait = 150

filter timestamp {"$(Get-Date -Format G): $_"}

foreach ($server in $serverlist)
    {
        Write-Output "Shutting down $server and waiting 2.5 minutes for full shutdown." | timestamp
        
        Stop-Computer -ComputerName $server -Force -Whatif
        
        sleep $wait
    }