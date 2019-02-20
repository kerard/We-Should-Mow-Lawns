$mailboxes = Get-Mailbox -Database EX_DB1

foreach ( $mailbox in $mailboxes)
	{
        		
        Get-MailboxStatistics $mailboxes.Alias | Format-List DisplayName,TotalItemSize
	}