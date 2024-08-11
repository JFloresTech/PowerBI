# See the Readme.md for the prerequisite configuration of an Azure registered enterprise app and the Power BI service
# This script can then be used to setup the credentials for a service princpal that can be used for automation
# A service principal is not the most secure method authentication for apps, an app certificate or managed identity would be better along with a key vault 

# This allows the unattended download, and installation of these trusted modules
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope UserPolicy # Can be set to -Scaope LocalMachine but you may not permissions
Set-PSRepository PSGallery -InstallationPolicy Trusted

# Microsoft.Graph is very large so its better to only install the modules needed
Install-Module Microsoft.Graph.Application
Install-Module Microsoft.Graph.Authentication
Install-Module MicrosoftPowerBIMgmt

#MS Login prompt for your credentials 
Connect-MgGraph

$TenantID = "Your Azure Entra AD Tenant ID"
$AppId = "Your Registered Appication (Client) ID"
$ServicePrincipalId = (Get-MgServicePrincipalByAppId -AppId $AppId).Id
$ServicePrincipalPassword = Add-MgServicePrincipalPassword -ServicePrincipalId $ServicePrincipalId

# Useful to store the Service Principal Password as JSON if you want to store it in a vault or use it else where
ConvertTo-Json $ServicePrincipalPassword > "Your Path here"


#Create secure string & credential for application id and client secret
$PbiSecurePassword = ConvertTo-SecureString $ServicePrincipalPassword.SecretText -Force -AsPlainText
$PbiCredential = New-Object Management.Automation.PSCredential($AppId, $PbiSecurePassword)

#Connect to the Power BI service and test that the credentials work properly
Connect-PowerBIServiceAccount -ServicePrincipal -TenantId $TenantId -Credential ($PbiCredential)

# Test the Service Principal has authorization to perform the necessary actions
New-PowerBIReport -Path "Updated report file path" -Name 'Your reports name' -WorkspaceId 'Your workspaces ID without it will push to personal workspace' -ConflictAction Overwrite

Disconnect-PowerBIServiceAccount

<#
Issue:
    Add-MgServicePrincipalPassword : Property passwordCredentials is invalid.
    ErrorCode: CannotUpdateLockedServicePrincipalProperty

 Solution: Update App Object Property servicePrincipalLockConfiguration

    $params = @{
        isEnabled = $false
        allProperties = $false
    }
    Update-MgApplicationByAppId -AppId $AppId -servicePrincipalLockConfiguration $params   

#>