
#This will allow unattended installation of pwsh modules
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
Set-PSRepository PSGallery -InstallationPolicy Trusted

# Pwsh Power BI Module is Small, you could do  MicrosoftPowerBIMgmt.Reports to make it even smaller
Install-Module -Name MicrosoftPowerBIMgmt

# GHSecret is the name of an environment variable defined in PowerBIReportOverwrite.yml
# this will authenticate

$PbiSecurePassword = ConvertTo-SecureString (ConvertFrom-Json $Env:POWERBISPPWD).SecretText -Force -AsPlainText
$PbiCredential = New-Object Management.Automation.PSCredential($Env:POWERBIAPPID, $PbiSecurePassword)

Connect-PowerBIServiceAccount -ServicePrincipal -TenantId "f36e21c5-5429-44e6-af9a-509c3aa07761" -Credential ($PbiCredential)

# New-PowerBIReport will push a the .PBIX to the workspace 
# Replace the current report with the new report file from the targe path with an Overwrite reflected in a few mintues to 1 hour
New-PowerBIReport -Path "./Europe Sales Report.pbix" -Name 'Europe Sales Report' -WorkspaceId $ESRWKSPID -ConflictAction Overwrite