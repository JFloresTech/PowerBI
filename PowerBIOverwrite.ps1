
#This will allow unattended installation of pwsh modules
Set-PSRepository PSGallery -InstallationPolicy Trusted

# Pwsh Power BI Module is Small, you could do  MicrosoftPowerBIMgmt.Reports to make it even smaller
Install-Module -Name MicrosoftPowerBIMgmt


# Github Secrets are encrypted to and on Github, and only decrypted in the runner when used
# 

$PbiSecurePassword = ConvertTo-SecureString (ConvertFrom-Json $Env:POWERBISPPWD).SecretText -Force -AsPlainText
$PbiCredential = New-Object Management.Automation.PSCredential($Env:POWERBIAPPID, $PbiSecurePassword)

Connect-PowerBIServiceAccount -ServicePrincipal -TenantId $Env:JFTECHTENANTID -Credential ($PbiCredential)

# New-PowerBIReport will push the .pbixto the workspace 
# Replace the current report with the new report file from the targe path with an Overwrite reflected in a few mintues to 1 hour
New-PowerBIReport -Path "./Europe Sales Report.pbix" -Name 'Europe Sales Report' -WorkspaceId $Env:ESRWKSPID -ConflictAction Overwrite