#
# Windows PowerShell script for AD FS Deployment
#

Import-Module ADFS

# Get the credential used for the federation service account
# This credential is created using the "New-ADServiceAccount FsGmsa" command below...

New-ADServiceAccount FsGmsa -DNSHostName ws1.cinco.local -ServicePrincipalNames http/ws1.cinco.local

$serviceAccountCredential = Get-Credential -Message "Enter the credential for the Federation Service Account.  Hint: FsGmsa"

# The "CertificateThumbprint" portion below needs work.  Try getting a thumbprint from a certificate we paid for.

Install-AdfsFarm `
-CertificateThumbprint:"DAE96F08D643AB7B5443CC20F4F7F04EB45BDBC3" `
-FederationServiceDisplayName:"Cinco Corporation" `
-FederationServiceName:"WS1.cinco.local" `
-ServiceAccountCredential:$serviceAccountCredential