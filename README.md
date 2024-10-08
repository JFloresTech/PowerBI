<h1>Power BI, SQL, Azure, PowerShell, and Github: Data Analysis, Database Developement, Cloud Automation, and CI/CD</h1>

This project showcases the use of Power BI report developement, T-SQL developement, Azure configuration, PowerShell scripting, and Github automation.

The Power BI Service is starting to integrate Github and Azure DevOps for source control. Currently in preview status, a Power BI premium license will be needed for Githb integration via the Power BI Service.
If you dont want to pay for a premium license this can currently be accomplished with a little overhead to integrate GIT and CI/CD auotomation.

What's included:
- Power BI report with an imported CSV data set
- CSV data set
- T-SQL scripts for importing the CSV data to a SQL Server environment
- Azure Enterprise Application registration
- Registered App API configuration
- Power BI Service configuration for service principal activity
- PowerShell script for creating service principal credentials
- PowerShell script for automated Power BI report deployments to the Power BI Service
- Github Actions workflow for automatic deployment when the report is updated
- Github Secrets for secure encrypted storage of secrets

<h2>Power BI Report</h2>
<a href="https://app.powerbi.com/view?r=eyJrIjoiNWY5MDgxMWQtYTM2Zi00YmExLTg5NzktZDhmMTk5YzBjOWQ0IiwidCI6ImYzNmUyMWM1LTU0MjktNDRlNi1hZjlhLTUwOWMzYWEwNzc2MSJ9&pageName=ReportSectionb20cb185ce329cea8bfc" target="_blank" rel="noopener noreferrer"><img src="https://github.com/JFloresTech/PowerBI/blob/main/Europe%20Sales%20Report%20.jpg"></a>

  This Power BI report is Publish to Web (Public) and is updated by PowerBIReportOverwrite.yml workflow.
  - CSV import of dataset 
  - Bookmark buttons for navigation and slicer configuration
  - DAX caclulated columns and measures 

<h2>Azure and Power BI Service Configuration</h2>
<h3>Step 1 - Create an Azure AD app</h3>
Creating an Azure AD app using a PowerShell script

``` PowerShell
# Microsoft.Graph is very large so its better to only install the modules needed
Import-Module Microsoft.Graph.Application
Import-Module Microsoft.Graph.Authentication
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

# Create the Service Principal password
$ServicePrincipalPassword = Add-MgServicePrincipalPassword -ServicePrincipalId $ServicePrincipalId

# Useful to store the Service Principal Password as JSON if you want to store it in a vault or use it else where
ConvertTo-Json $ServicePrincipalPassword > "[Your Path here]"
```
<h3>Step 2 - Create an Azure AD security group</h3>
Your service principal doesn't have access to any of your Power BI content and APIs. To give the service principal access, create a security group in Azure AD, and add the service principal you created to that security group.

Creating an Azure AD security group using a PowerShell script
``` PowerShell
# Microsoft.Graph is very large so its better to only install the modules needed
Import-Module Microsoft.Graph.Application
Import-Module Microsoft.Graph.Authentication
Connect-MgGraph
  
# Create a Security group for the Power BI Service Fabric API access
$group = New-MgGroup -DisplayName "[Group Name Here]" -SecurityEnabled -MailEnabled:$False -MailNickName "notSet"

# Add the App to the group
New-MgGroupMember -GroupId $($group.Id) -DirectoryObjectId $ServicePrincipalId
```
<h3>Step 3 - Enable the Power BI service admin settings</h3>
For an Azure AD app to be able to access the Power BI content and APIs, a Power BI admin needs to enable service principal access in the Power BI admin portal.
<ul>
Navigate to to Power BI Admin Portal: https://app.powerbi.com/admin-portal/tenantSettings
<li>Scroll down to the Developer settings section</li>
<li>Expand the Allow service principals to use Power BI APIs setting</li>
<li>Click on the enable toggle to enable the setting</li>
<li>Choose Specific security groups (Recommended) in the 'Apply to' radio buttons</li>
<li>Add the security group created in step 2 in the textbox</li>
<li>Click on Apply button to save the setting</li>
</ul>
Screenshot of the Development settings in the Power BI Admin portal 

<h3>Step 4 - Required API permissions</h3>
To access the Power BI APIs vai the Power BI CLI, the service principal need several scope assigned. In the table below is an overview of the required scopes.
<ul>
<li>Admin: Tenant.Read.All, Tenant.ReadWrite.All</li>
<li>App: App.Read.All</li>
<li>Capacity: Capacity.Read.All, Capacity.ReadWrite.All</li>
<li>Dashboard: Dashboard.Read.All, Dashboard.ReadWrite.All, Content.Create</li>
<li>Dataflow: Dataflow.ReadWrite.All, Dataflow.Read.All</li>
<li>Dataset: Dataset.ReadWrite.All, Dataset.Read.All</li>
<li>Gateway: Dataset.Read.All, Dataset.ReadWrite.All</li>
<li>Import: Dataset.ReadWrite.All</li>
<li>Report: Report.Read.All, Report.ReadWrite.All, Dataset.Read.All, Dataset.ReadWrite.All</li>
<li>Workspace: Workspace.Read.All, Workspace.ReadWrite.All</li>
</ul>
Adding the scopes as API permissions can be done via the Azure Portal on the management pane of the service principal.

Note
For the Tenant.Read.All and Tenant.ReadWrite.All scopes Admin consent is needed. This can be applied via the Azure portal.

Screenshot of adding API permissions for the service principal

<h3>Step 5 - Add the service principal to your workspace</h3>
To enable your Azure AD app access artifacts such as reports, dashboards and datasets in the Power BI service, add the security group that includes your service principal, as a member or admin to your workspace.

Alternatively you can add the service principal as Fabric administrator via Priviliged Identity Management with an Entra AD P2 license included with E5.

<h2>PowerShell Automation</h2>
PowerBIServicePrincipalSetup.ps1:
<ul>
<li>PowerShell script template for creating the service principal credentials after the application and Power BI service have been configured.</li>
</ul>
PowerBIReportOverwrite.ps1:
<ul>
<li>Used by the Github workflow PowerBIReportOverwrite.yml to perform the task of updating the report.</li>
<li>Uses Github Secrets to securely store and retrieve secrets, instead of storing in the script.</li>
</ul>

<h2>Github Actions Automation</h2>
PowerBIReportOverwrite.yml:
<ul>
<li>The Github workflow that provisions the runner, imports the repository and secrets in to the environment, and then runs the PowerBIOverwrite.ps1 to perform the task, and send notification.</li>
</ul>
