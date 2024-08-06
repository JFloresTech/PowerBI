#GHSecret is the name of an environment variable defined in PowerBIReportOverwrite.yml
# this will authenticate

Set-PSRepository PSGallery -InstallationPolicy Trusted

Install-Module Microsoft.Graph.Application, Microsoft.Graph.Authentication

Connect-MgGraph


$app = 'fd467211-dac5-4f3e-a71f-e99e561a7ecc'

# Creates a service principal
$sp = New-AzureADServicePrincipal -AppId $app

# Get the service principal key
$key = New-AzureADServicePrincipalPasswordCredential -ObjectId $sp.ObjectId

#Install-Module -Name MicrosoftPowerBIMgmt -y

#Connect-PowerBIServiceAccount -Tenant $GHSecret.TenentID -ApplicationId $GHSecret.ApplicationId -ServicePrincipal $GHSecret.ServicePrincipal -Credential $GHSecret.Credential