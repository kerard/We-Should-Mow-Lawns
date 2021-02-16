$userinput = Read-Host "Please provide locked user name"

# $lockeduser = '*Matt_Cinco_GreatJob*'

# $lockeduser = '*$userinput*'

# $userinput
# $lockeduser

Get-ADUser -Filter * | ? {$_.UserPrincipalName -like $userinput} | Unlock-ADAccount -WhatIf