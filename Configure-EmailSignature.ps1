New-TransportRule -Name 'Corporate External Signature and Disclaimer' `
                  -FromScope 'InOrganization' `
                  -SentToScope 'NotInOrganization' `
                  -ApplyHtmlDisclaimerText '<br>Regards,<br>%%DisplayName%%<br>%%Title%%<br><hr>The following <a href="http://www.yourcompany.com/emaildisclaimer.htm">disclaimer</a> applies to this message.' `
                  -ApplyHtmlDisclaimerFallbackAction 'Wrap'