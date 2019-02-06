Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)

New-ADServiceAccount FsGmsa -DNSHostName ws1.cinco.local -ServicePrincipalNames http/ws1.cinco.local