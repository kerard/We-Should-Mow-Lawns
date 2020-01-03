$userinput = Read-Host "Please provide locked user name"

# $lockeduser = '*Matt_Bundt_Admin*'

# $lockeduser = '*$userinput*'

# $userinput
# $lockeduser

Get-ADUser -Filter * | ? {$_.UserPrincipalName -like $userinput} | Unlock-ADAccount -WhatIf