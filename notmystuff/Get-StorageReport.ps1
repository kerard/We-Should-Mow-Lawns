<# 
    .SYNOPSIS 
    Creates a HTML Report describing Storage Spaces Status 
    
       Michael Rüefli (www.miru.ch) 
     
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
     
    Version 1.2.0 (stable), January 22th, 2015 
     
    .DESCRIPTION 
     
    This script creates a HTML report showing the following information about a Windows 
    Storage Spaces environment. 
     
    * Report Generation Time, Reported Node 
    * Storage Pools 
    * Storage Enclosures 
    * Virtual Disks 
    * Physical Disks with Enclosure Mapping 
    * MPIO Path Information per physical Disk 
    * Storage Spaces Driver Events 
    * Storage Tiering Statistics 
     
    IMPORTANT NOTE: The script requires administrative privileges on the remote server. It 
    gathers the information via persistent WinRM session. 
     
    .PARAMETER StorageNode 
    The hostname of the storage node to query 
 
    .PARAMETER IncludeMPIO 
    This switch enables MPIO Information gathering 
     
    .PARAMETER IncludeEvents 
    This switch enables Eventlog Information gathering 
 
    .PARAMETER IncludeTieringStats 
    This switch enables Storage Tiering statistics gathering 
 
    .PARAMETER OutputFile 
    This parameter can be used to select an alternate output file location than %TEMP%\StorageReport.html 
 
    .PARAMETER IncludeEvents 
    This switch opens the report file with the default handler right after creation 
 
    .PARAMETER MailFrom 
    Email address to send to. Passed directly to Send-MailMessage as -From 
     
    .PARAMETER MailTo 
    Email address to send to. Passed directly to Send-MailMessage as -To 
     
    .PARAMETER MailServer 
    SMTP Mail server to attempt to send through. Passed directly to Send-MailMessage as -SmtpServer 
     
    .EXAMPLE 
    Generate the HTML report and send it via Email 
    .\CreateStorageReport.ps1 -StorageNode SOFSN01 -IncludeMPIO -IncludeEvents -OutputFile C:\Reports\StorageReport_demo.html -MailFrom storage@domain.com -Mailto support@domain.com -MailServer smtp.domain.com 
 
    .NOTES 
    Changes / Bugfixes 
    V 1.1.0 
    - Fixed Storage Enclosure Sensor Health errors 
    - Added Physical Disk Reliability Counters 
    - Fixed Pool gathering where physical disks where displayed multiple times 
    - changed -Mailto Parameter to be an array of Strings to support multiple recipients 
 
    V 1.2.0 
    - Added Storage Tiering Statistics (-IncludeTieringStats) 
    #> 
 
Param( 
    [Parameter(Mandatory=$true)] 
    [STRING]$StorageNode, 
     
    [Parameter(Mandatory=$false)] 
    [SWITCH]$IncludeMPIO, 
 
    [Parameter(Mandatory=$false)] 
    [SWITCH]$IncludeEvents, 
 
    [Parameter(Mandatory=$false)] 
    [SWITCH]$IncludeTieringStats, 
 
    [Parameter(Mandatory=$false)] 
    [STRING]$OutPutFile="$ENV:TEMP\StorageReport_$StorageNode.html", 
 
    [Parameter(Mandatory=$false)] 
    [SWITCH]$OpenFileAfterCreation, 
     
    [Parameter(Mandatory=$false)] 
    [STRING]$MailFrom, 
 
    [Parameter(Mandatory=$false)] 
    [STRING[]]$MailTo, 
 
    [Parameter(Mandatory=$false)] 
    [STRING]$MailServer 
) 
 
$VerbosePreference="continue" 
 
#Create Persistent Remote Session 
Write-Verbose "Creating new WinRM Ression with Computer: $StorageNode" 
$PSSession = New-PSSession -ComputerName $StorageNode 
 
#region data gathering 
#Get Storage Enclosure Info 
Write-Verbose "Gathering Enclosure Information" 
$Enclosures = Invoke-Command -Session $PSSession { 
    $Enclosures = Get-StorageEnclosure | select * 
    $EnclosureInfo = @() 
    Foreach ($e in $Enclosures) 
    { 
 
        $eFANState = $e.FANOperationalStatus -join "." 
        $ePWRSupplyState = $e.PowerSupplyOperationalStatus -join "." 
        $eIOContrState = $e.IOControllerOperationalStatus -join "." 
        $eTempSensorState = $e.TemperatureSensorOperationalStatus -join "." 
 
        $encinfo = New-Object -TypeName PSObject -Property @{ 
            FriendlyName=$e.FriendlyName 
            UniqueID=$e.UniqueId 
            SerialNumber=$e.SerialNumber 
            Firmware=$e.FirmwareVersion 
            Slots=$e.NumberOfSlots 
            HealthState=$e.HealthStatus 
            IOControllerState=$eIOContrState 
            FANState=$eFANState 
            PowerSupplyState=$ePWRSupplyState 
            TemperatureSensorState=$eTempSensorState 
        } 
        $EnclosureInfo += $encinfo 
    } 
    return $EnclosureInfo  
} 
 
#Get Storage Pool Info 
Write-Verbose "Gathering Storage Pool Information" 
$StoragePoolInfo = Invoke-Command -Session $PSSession { 
    $StoragePoolInfo = @() 
    $StoragePools = Get-StoragePool | Where-Object {$_.FriendlyName -ne 'Primordial'}  
    Foreach ($sp in $StoragePools) 
    { 
        $PoolObject = New-Object -TypeName PSObject -Property @{ 
            FriendlyName=$sp.FriendlyName 
            SizeGB=($sp.Size / 1GB) 
            AllocatedGB=($sp.AllocatedSize / 1GB) 
            AllocatedPercent=[System.Math]::Round((100/$sp.Size)*($sp.AllocatedSize), 2) 
            IsClustered=$sp.IsClustered 
            EnclosureAwareDefault=$sp.EnclosureAwareDefault 
            OperationalStatus=$sp.OperationalStatus 
            HealthStatus=$sp.HealthStatus 
        } 
        $StoragePoolInfo += $PoolObject 
    } 
    Return $StoragePoolInfo 
} 
 
#Get virtual Disks 
Write-Verbose "Gathering Virtual Disk (Spaces) Information" 
$VirtualDiskInfo = Invoke-Command -Session $PSSession { 
    $StoragePools = Get-StoragePool 
    $VirtualDiskInfo = @() 
 
    Foreach ($sp in $StoragePools) 
    { 
        $VirtualDisks = Get-VirtualDisk -StoragePool $sp 
        Foreach ($vd in $VirtualDisks) 
        { 
            $StorageTiers = $vd  | Get-StorageTier 
            If ($StorageTiers) 
            { 
                Write-Verbose "Gathering Storage Tier Information" 
                $IsTiered=$true 
            } 
            Else 
            { 
                $IsTiered=$false 
            } 
             
            $VirtualDiskobj = New-Object -TypeName PSObject -Property @{ 
            FriendlyName=$vd.FriendlyName 
            StoragePool=$sp.FriendlyName 
            ResiliencySettingName=$vd.ResiliencySettingName 
            NumberOfDataCopies=$vd.NumberOfDataCopies 
            NumberofColumns=$vd.NumberofColumns 
            Interleave=$vd.Interleave 
            IsEnclosureAware=$vd.IsEnclosureAware 
            SizeGB=($vd.Size / 1GB) 
            WriteCacheSizeGB=($vd.WriteCacheSize / 1GB) 
            IsTiered=$IsTiered 
            SSDTierSizeGB=(($StorageTiers | Where-Object {$_.MediaType -eq 'SSD'}).Size / 1GB) 
            HDDTierSizeGB=(($StorageTiers | Where-Object {$_.MediaType -eq 'HDD'}).Size / 1GB) 
            OperationalStatus=$vd.OperationalStatus 
            HealthStatus=$vd.HealthStatus 
            } 
            $VirtualDiskInfo += $VirtualDiskobj 
        }       
 
    }   
    Return $VirtualDiskInfo 
} 
 
 
#Get Physical Disks 
Write-Verbose "Gathering Physical Disk Information" 
$PhysicalDiskInfo = Invoke-Command -Session $PSSession { 
    $Enclosures = $USING:Enclosures 
    $PhysicalDiskInfo = @() 
 
    $pdisks = Get-PhysicalDisk | where {($_.canpool) -or ($_.CannotPoolReason -match 'In a Pool')} 
    Foreach ($pd in $pdisks) 
    { 
        $opsdata = Get-StorageReliabilityCounter -PhysicalDisk $pd 
        $findstrg = $pd.PhysicalLocation -match '[0-9a-z]{16}' 
        $EnslosureID = $matches[0] 
        $dskobj = New-Object -TypeName PSObject -Property @{ 
            Name=$pd.FriendlyName 
            Slot=$pd.SlotNumber 
            EnclosureID=($EnslosureID) 
            EnclosureSerial=($Enclosures | where-object {$_.UniqueId -eq $EnslosureID}).SerialNumber 
            HealthState=$pd.HealthStatus 
            Manufacturer=$pd.Manufacturer 
            Model=$pd.Model 
            FirmwareVersion=$pd.FirmwareVersion 
            OperationalState=$pd.OperationalStatus 
            MediaType=$pd.MediaType 
            SizeGB=($pd.Size /1GB) 
            Usage=$pd.Usage 
            ID=$pd.UniqueId 
            SerialNumber=$pd.SerialNumber 
            PowerOnHours=$opsdata.PowerOnHours 
            Temperature=$opsdata.Temperature 
            TemperatureMax=$opsdata.TemperatureMax 
            StartStopCycleCount=$opsdata.StartStopCycleCount 
            MaxReadLatency_ms=$opsdata.ReadLatencyMax 
            MaxWriteLatency_ms=$opsdata.WriteLatencyMax 
            ReadErrors=$opsdata.ReadErrorsTotal 
            WriteErrors=$opsdata.WriteErrorsTotal 
        } 
        $PhysicalDiskInfo += $dskobj 
        } 
    Return $PhysicalDiskInfo 
} 
 
If ($IncludeMPIO) 
{ 
    #Get MPIO Info 
    Write-Verbose "Gathering MPIO Path Information per Disk" 
    $MPIOPathInfo = Invoke-Command -Session $PSSession -ScriptBlock { 
        $StoragePools = Get-StoragePool | Where-Object {$_.FriendlyName -ne 'Primordial'}  
        $MPIOInfo = $StoragePools | Get-PhysicalDisk | Foreach-Object {mpclaim -s -d $_.DeviceID} 
        Return $MPIOInfo 
    } | Select-String "paths" 
} 
 
 
If ($IncludeEvents) 
{ 
    Write-Verbose "Gathering Storage Spaces Driver Events" 
    #Get Storage Spaces Driver Events 
    $StorageSpaceDriverEvts = Invoke-Command -Session $PSSession -ScriptBlock { 
        Get-WinEvent -LogName "Microsoft-Windows-StorageSpaces-Driver/Operational" 
    } 
} 
 
If ($IncludeTieringStats) 
{ 
    #Get Storage Tiering Statistics 
    Write-Verbose "Gathering Storage Tiering Statistics" 
    $TieringStats = Invoke-Command -Session $PSSession -ScriptBlock { 
 
        $TierStats=@() 
        $StorageOptInfo = get-winevent -LogName "Microsoft-Windows-Storage-Tiering/Admin" | ? {$_.ID -eq 22} 
        Foreach ($entry in $StorageOptInfo) 
        { 
            $entrydate=$entry.TimeCreated 
            $info = $entry.Message 
            $info -match 'Percent of total I/Os serviced from the SSD tier: [0-9]{1,3}%' | out-null ; $FastTierHitRate = $matches[0]         
            $info -match 'Current size of the faster .* tier: [0-9]{1,3},[0-9]{1,2}.*?GB' | out-null ; $CurrentFastTierSize = $matches[0]         
            $info -match '100%.*?[0-9]{1,3},[0-9]{1,2}.*?[G|M|K|T]B' | out-null; $FastTierSizeReq100 = ($matches[0]).trim() 
            $info -match '95%.*?[0-9]{1,3},[0-9]{1,2}.*?GB|MB|KB' | out-null; $FastTierSizeReq95 = $matches[0] 
            $info -match '90%.*?[0-9]{1,3},[0-9]{1,2}.*?GB|MB|KB' | out-null; $FastTierSizeReq90 = $matches[0] 
            $info -match '85%.*?[0-9]{1,3},[0-9]{1,2}.*?GB|MB|KB' | out-null; $FastTierSizeReq85 = $matches[0] 
            $info -match '80%.*?[0-9]{1,3},[0-9]{1,2}.*?GB|MB|KB' | out-null; $FastTierSizeReq80 = $matches[0] 
            $info -match '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}' | out-null; [string]$VolumeGuid = $matches[0] 
            $Volume = get-volume | ? {$_.path -match $VolumeGuid} 
            $VolumeName = $Volume.FileSystemLabel 
            $volinfo = New-Object -TypeName PSObject -Property @{ 
                Date=$entrydate 
                VolumeName=$VolumeName 
                FastTierSize=$CurrentFastTierSize 
                FastTierHitRate=$FastTierHitRate 
                FastTierRequiredSize="$FastTierSizeReq100; $FastTierSizeReq90; $FastTierSizeReq80" 
            } 
            $TierStats += $volinfo 
 
        } 
        Return $TierStats 
    }     
} 
#endregion 
 
 
#Remove Persistent Remote Session 
Write-Verbose "Removing WinRM Session" 
$PSSession | Remove-PSSession 
 
 
#region output formatting 
Write-Verbose "Constructing Output" 
$Output = "" 
$TableHdr = @" 
 
BODY{background-color:white;} 
TABLE{border-width: 1px;border-style: solid;border-color: grey;border-collapse: collapse;} 
TH{border-width: 1px;padding: 4px;border-style: solid;border-color: grey;background-color:#000099;font-family:arial;font-size: 8pt; color: #FBFBEF;} 
TD{border-width: 1px;padding: 4px;border-style: solid;border-color: grey;font-family:arial;font-size: 8pt; color: black;} 
 
"@ 
 
 
 
$Output+="<html> 
<body> 
<font size=""2"" face=""Arial,sans-serif""> 
<h2 align=""center"">Storage Spaces Report</h3> 
<h3 align=""center"">Node: $StorageNode</h3> 
<h5 align=""center"">Generated $((Get-Date).ToString())</h5> 
</font>" 
 
$output += "<html> 
<body> 
<font size=""3"" face=""Arial,sans-serif""> 
<h3 align=""left"">Storage Pools</h3> 
</font>" 
$output += $StoragePoolInfo | ConvertTo-Html -Property FriendlyName,SizeGB,AllocatedGB,AllocatedPercent,EnclosureAwareDefault,IsClustered,OperationalStatus,HealthStatus -Head $TableHdr | Foreach { 
    If ($_ -like "*<td>Healthy</td>*")  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#CEF6CE>" 
    } 
    Else  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
    } 
} 
$Output += " " 
 
$output += "<html> 
<body> 
<font size=""3"" face=""Arial,sans-serif""> 
<h3 align=""left"">Virtual Disks ( $($VirtualDiskInfo.count) )</h3> 
</font>" 
$output += $VirtualDiskInfo | ConvertTo-Html -Property FriendlyName,StoragePool,ResiliencySettingName,NumberOfDataCopies,NumberofColumns,Interleave,IsEnclosureAware,SizeGB,WriteCacheSizeGB,IsTiered,SSDTierSizeGB,HDDTierSizeGB,OperationalStatus,HealthStatus -Head $TableHdr | Foreach { 
    If ($_ -like "*<td>Healthy</td>*")  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#CEF6CE>" 
    } 
    Else  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
    } 
} 
$Output += " " 
 
 
$output += "<html> 
<body> 
<font size=""3"" face=""Arial,sans-serif""> 
<h3 align=""left"">Storage Enclosures ( $($Enclosures.count) )</h3> 
</font>" 
$output += $Enclosures | Sort-Object FriendlyName | ConvertTo-Html -Property FriendlyName,UniqueId,SerialNumber,Firmware,Slots,HealthState,PowerSupplyState,FANState,IOControllerState,TemperatureSensorState -Head $TableHdr | Foreach { 
    If ($_ -like "*<td>Healthy</td>*")  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#CEF6CE>" 
    } 
    ElseIf ($_ -like "*<td>Unknown</td>*")  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#FFFF99>" 
    } 
    Else  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
    } 
} 
$Output += " " 
 
$output += "<html> 
<body> 
<font size=""3"" face=""Arial,sans-serif""> 
<h3 align=""left"">Physical Disks ( $($PhysicalDiskInfo.count) )</h3> 
</font>" 
$output += $PhysicalDiskInfo | Sort-Object MediaType -Descending |  ConvertTo-Html -Property Name,Slot,Id,EnclosureID,EnclosureSerial,Mediatype,SizeGB,Manufacturer,Model,SerialNumber,FirmwareVersion,usage,OperationalState,HealthState,MaxReadLatency_ms,MaxWriteLatency_ms $TableHdr | Foreach { 
    If ($_ -like "*<td>Healthy</td>*")  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#CEF6CE>" 
    } 
    Else  
    { 
        $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
    } 
} 
$Output += " " 
 
If ($IncludeMPIO) 
{ 
    $output += "<html> 
    <body> 
    <font size=""3"" face=""Arial,sans-serif""> 
    <h3 align=""left"">MPIO Disk Path Info</h3> 
    </font>" 
    $output += $MPIOPathInfo |  ConvertTo-Html -Property Line | Foreach { 
        If ($_ -like "*02 Paths*")  
        { 
            $_ -replace "<tr>", "<tr bgcolor=#CEF6CE>" 
        } 
        Else  
        { 
            $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
        } 
    } 
    $Output += " " 
} 
 
If ($IncludeEvents) 
{ 
    $output += "<html> 
    <body> 
    <font size=""3"" face=""Arial,sans-serif""> 
    <h3 align=""left"">Storage Space Driver Events</h3> 
    </font>" 
    $output += $StorageSpaceDriverEvts |  ConvertTo-Html -Property TimeCreated,ID,LevelDisplayName,Message | Foreach { 
        If ($_ -like "*<td>Warning</td>*")  
        { 
            $_ -replace "<tr>", "<tr bgcolor=#FFFF99>" 
        } 
        ElseIf ($_ -like "*<td>Error</td>*") 
        { 
            $_ -replace "<tr>", "<tr bgcolor=#F6CEE3>" 
        } 
        Else  
        { 
            $_ -replace "<tr>", "<tr bgcolor=#66CCFF>" 
        } 
    } 
} 
 
If ($IncludeTieringStats) 
{ 
    $output += "<html> 
    <body> 
    <font size=""3"" face=""Arial,sans-serif""> 
    <h3 align=""left"">Storage Tiering Statistics</h3> 
    </font>" 
    $output += $TieringStats |  ConvertTo-Html -Property Date,VolumeName,FastTierSize,FastTierHitRate,FastTierRequiredSize 
 
} 
#endregion 
 
 
#Generate the output file 
Write-Verbose "Writing Output to File $OutPutFile" 
$output | Out-File $OutPutFile -Force 
 
#Openfile with default handler if switch is present 
Write-Verbose "Opening Outputfile $OutPutFile" 
If ($OpenFileAfterCreation) 
{ 
    Invoke-Item  $OutPutFile 
} 
 
#Mail the Report 
If ($MailTo -and $MailFrom -and $MailServer) 
{ 
    Send-MailMessage -From $MailFrom -To $MailTo -SmtpServer $MailServer -Attachments $OutPutFile -Subject "Storage Spaces Report: $StorageNode" -Encoding UTF8 -BodyAsHtml -Body $output 
} 
 
Write-Verbose "Report Created Successfully"