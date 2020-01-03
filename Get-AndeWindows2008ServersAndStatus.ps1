Get-ADComputer -SearchBase 'DC=andent,DC=andersonsinc,DC=com' -Filter {OperatingSystem -Like "Windows Server 200*"} -Property * | ForEach-Object `
    {
        
        $d1 = ([datetime]::FromFileTime($_.LastLogonTimeStamp))
        $d2 = Get-Date
        $ts = New-TimeSpan -Start $d1 -End $d2
       
        $rtn = Test-Connection -CN $_.dnshostname -Count 1 -BufferSize 16 -Quiet

        if ($rtn -match 'True') 
            {
                write-host -ForegroundColor green $_.dnshostname "responded to ping.  Last logon was" $ts.Days "days ago on" $d1
            }

        else 
            {
                Write-host -ForegroundColor red $_.dnshostname "did not respond to ping.  Last logon was" $ts.Days "days ago on" $d1
            }

        [pscustomobject]@{
                "Hostname" = $_.dnshostname
                "Online" = $rtn
                "Last Logon" = $d1
				"Days Ago" = $ts.Days
			}

    } | Export-Csv "C:\Users\mw148186\OneDrive - The Andersons, Inc\OUTPUT_Get-AndeWindows2008ServersAndStatus.csv" -NoTypeInformation