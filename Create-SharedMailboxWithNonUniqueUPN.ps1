
# +++
# O365 and Exchange Online error out if you try to create a shared mailbox with a UPN that is already in use, depsite different suffix.
# For example, trying to create shared mailbox "info@thompsonsbeans.com" yields an error because "info@andersonsinc.com" already exists.

New-Mailbox -Name "Thompsons Beans Information" -Alias infothompsonsbeans -Shared -PrimarySMTPAddress info@thompsonsbeans.com

Get-Mailbox infothompsonsbeans | Select UserPrincipalName

Set-Mailbox infothompsonsbeans -MicrosoftOnlineServicesID info@thompsonsbeans.com