Import-Module "C:\\Program Files\\Common Files\\Skype for Business Online\\Modules\\SkypeOnlineConnector\\SkypeOnlineConnector.psd1"

# Since MFA is enabled on _el accounts, do not specify credentials.
$session = New-CsOnlineSession
Import-PSSession $session -AllowClobber

Get-CsOnlineUser -Identity "tuser3" | fl *voice*,*PSTN*,*lineuri*,ObjectID,*SIP*,UserPrincipalName