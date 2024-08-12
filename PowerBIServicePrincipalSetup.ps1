# See the Readme.md for the prerequisite configuration of an Azure registered enterprise app and the Power BI service
# This script can then be used to setup the credentials for a service princpal that can be used for automation
# A service principal is not the most secure method authentication for apps, an app certificate or managed identity would be better along with a key vault 

# May be needed to run this script
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope User 

# This allows the unattended download, and installation of these trusted modules
Set-PSRepository PSGallery -InstallationPolicy Trusted

# Microsoft.Graph is very large so its better to only install the modules needed
Install-Module Microsoft.Graph.Application
Install-Module Microsoft.Graph.Authentication
Install-Module MicrosoftPowerBIMgmt

#MS Login prompt for your credentials 
Connect-MgGraph

#Create a new Azure Application
$params = @{
    DisplayName = "[App Name Here]"
    Web = @{
        RedirectUris = "https://localhost:44322"
        HomePageUrl = "https://localhost:44322"
    }
}
$App = New-MgApplication @params
$AppId = $App.AppId

# Create a service principal
$ServicePrinciple = New-MgServicePrincipal -AppId $AppId
$ServicePrincipalId = $ServicePrinciple.Id

# Create a Security group for the Power BI Service Fabric API access
$group = New-MgGroup -DisplayName "[Group Name Here]" -SecurityEnabled -MailEnabled:$False -MailNickName "notSet"

# Add the App to the group
New-MgGroupMember -GroupId $($group.Id) -DirectoryObjectId $ServicePrincipalId

# Create the Service Principal password
$ServicePrincipalPassword = Add-MgServicePrincipalPassword -ServicePrincipalId $ServicePrincipalId

# Useful to store the Service Principal Password as JSON if you want to store it in a vault or use it else where
ConvertTo-Json $ServicePrincipalPassword > "[Your Path here]"


# Create a secure string & credential for application id and client secret
$PbiSecurePassword = ConvertTo-SecureString $ServicePrincipalPassword.SecretText -Force -AsPlainText
$PbiCredential = New-Object Management.Automation.PSCredential($AppId, $PbiSecurePassword)

$TenantID = "[Your Azure Entra AD Tenant ID]"

#Connect to the Power BI service and test that the credentials work properly
Connect-PowerBIServiceAccount -ServicePrincipal -TenantId $TenantId -Credential ($PbiCredential)

# Test the Service Principal has authorization to perform the necessary actions
New-PowerBIReport -Path "[Report file path]" -Name '[Your reports name]' -WorkspaceId '[Your workspaces ID without it will push to personal workspace]' -ConflictAction Overwrite

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