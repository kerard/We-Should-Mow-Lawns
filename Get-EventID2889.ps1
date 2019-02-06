# Get-EventID2889.ps1 by Mark Wilkerson
# 20 April 2017
# This script retrieves the server, timestamp, IP Address, and username from Event ID 2889 on a server\domain controller.
# See Microsoft article https://technet.microsoft.com/en-us/library/dd941856(v=ws.10).aspx regarding Event ID 2889
# The majority of this script is based off Geoff Duke's "Adventures in System Administration" blog at https://www.uvm.edu/~gcd/2010/11/event-data-mining-with-powershell/

# Replace these values as needed.
# Specify the server to query.
$server = 'ADMS2'

# Specify the working path.  This path is where the script will try to find the .xml file specified below.
$local_path = 'C:\Users\mark.wilkerson\Documents\Powershell ISE Things'

# Specify the .xml filter used to parse Windows logs.  
$xml_file_name = 'filter-2889.xml'

# Create an XML variable that holds the content of the .xml file.  This variable is used in the following Get-WinEvent cmdlet.
# Geoff Duke's blog does not include the [xml] prefix when this variable is declared.
# Prefix [xml] prepended based on information from https://powershell.org/forums/topic/importing-xml-string-with-powershell-variables/
[xml]$filter = gc $local_path\$xml_file_name

# Get all the events from the server specified above.
$events = get-winevent -ComputerName $server -filterXML $filter

# Echo a friendly meta statement.  "There are 1 event(s) on ADMS1."
Write-Host "`r`nThere are" $events.count "event(s) on $server.`r`n"

# Declare variables used to create a friendly table.

$time = @{ label='Time Created'; Expression={get-date $_.TimeCreated -format s} }

# The original $hostname variable declaration is provided below.
# $hostname = @{label='Hostname'; Expression={$_.MachineName.Substring(0,5)} }
# Geoff Duke was using 5 characters for server names.
# Use regex to enhance the script's ability to parse the hostname output.  Allow up to 15 characters, truncate ".keller.local".
# Derived from information in this article: https://social.technet.microsoft.com/wiki/contents/articles/4310.powershell-working-with-regular-expressions-regex.aspx#Replace
# Refer to "Regex Replace Using Found matches" section.
$hostname = @{label='Hostname'; Expression={$_.MachineName.Substring(0,14) -replace "\.(\w+)"} }

$ipaddr = @{ label="IP Address"; Expression={$_.properties[0].value} }
$client = @{ label="Client"; Expression={$_.properties[1].value} }
$events[0..9] | select $hostname, $time, $ipaddr, $client

# Variables declared, print list in terminal.
get-winevent -ComputerName $server -filterXML $filter | select $hostname,$time,$ipaddr,$client

# Export output to .csv.
get-winevent -ComputerName $server -filterXML $filter | select $hostname,$time,$ipaddr,$client | export-csv $local_path\$server-id2889.csv

# Echo some friendly metadata indicating location of .csv, number of events, and server reporting the events.
Write-Host "`r`nCheck $local_path\$server-id2889.csv for a complete list of" $events.count "event(s) on $server."