$userinput = Read-Host "Please provide a database name for the new virtual machine (e.g. EX_DB1)"

# Get-Mailbox -Database $userinput -ResultSize Unlimited | Get-MailboxStatistics | Select DisplayName,@{name="TotalItemSize (GB)"; expression={[math]::Round(($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1GB),2)}} | Sort "TotalItemSize (GB)" -Descending | ft

Get-Mailbox -Database $userinput -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName,TotalItemSize | Sort-Object TotalItemSize -Descending | Format-Table