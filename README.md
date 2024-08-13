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
<a href="https://app.powerbi.com/view?r=eyJrIjoiNWY5MDgxMWQtYTM2Zi00YmExLTg5NzktZDhmMTk5YzBjOWQ0IiwidCI6ImYzNmUyMWM1LTU0MjktNDRlNi1hZjlhLTUwOWMzYWEwNzc2MSJ9&pageName=ReportSectionb20cb185ce329cea8bfc"><img src="https://github.com/JFloresTech/PowerBI/blob/main/Europe%20Sales%20Report%20.jpg"></a>

  This Power BI report is Publish to Web (Public) and is updated by an overwrite.
  - CSV import of dataset 
  - Bookmark buttons for navigation and slicer configuration
  - DAX caclulated columns and measures 

<h2>Azure and Power BI Service Configuration</h2>
<h3>Step 1 - Create an Azure AD app</h3>
Create an Azure AD app using one of these methods and store the following information securely as it is needed:

Azure app's Application ID
Azure AD app's secret
Azure app's Tenant ID
Creating an Azure AD app in the Microsoft Azure portal
See the create an Azure AD app article for the steps. You can skip the 'Role' and 'Policy' parts.

Creating an Azure AD app using a script
This section includes a sample script to create a new Azure AD app using the Azure CLI or PowerShell.

Azure CLI PowerShell
<code>
# The app ID - $app.appid
# The service principal object ID - $sp.objectId
# The app key - $key.value

# Sign in as a user that's allowed to create an app
Connect-AzureAD

# Create a new Azure AD web application
$app = New-AzureADApplication -DisplayName <ApplicationName> -Homepage "https://localhost:44322" -ReplyUrls "https://localhost:44322"

# Creates a service principal
$sp = New-AzureADServicePrincipal -AppId $app.AppId

# Get the service principal key
$key = New-AzureADServicePrincipalPasswordCredential -ObjectId $sp.ObjectId
</code>
<h3>Step 2 - Create an Azure AD security group</h3>
Your service principal doesn't have access to any of your Power BI content and APIs. To give the service principal access, create a security group in Azure AD, and add the service principal you created to that security group.

Creating an Azure AD security group in the Microsoft Azure portal
See the create a basic group and add members using Azure AD article for the steps.

Creating an Azure AD security group using a script
Azure CLI PowerShell
<code>
# Required to sign in as admin
Connect-AzureAD

# Create an Azure AD security group
$group = New-AzureADGroup -DisplayName <GroupName> -SecurityEnabled $true -MailEnabled $false -MailNickName notSet

# Add the service principal to the group
Add-AzureADGroupMember -ObjectId $($group.ObjectId) -RefObjectId $($sp.ObjectId)
</code>
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

admin	Tenant.Read.All, Tenant.ReadWrite.All
app	App.Read.All
capacity	Capacity.Read.All, Capacity.ReadWrite.All
dashboard	Dashboard.Read.All, Dashboard.ReadWrite.All, Content.Create
dataflow	Dataflow.ReadWrite.All, Dataflow.Read.All
dataset	Dataset.ReadWrite.All, Dataset.Read.All
feature	None
gateway	Dataset.Read.All, Dataset.ReadWrite.All
import	Dataset.ReadWrite.All
report	Report.Read.All, Report.ReadWrite.All, Dataset.Read.All, Dataset.ReadWrite.All
workspace	Workspace.Read.All, Workspace.ReadWrite.All
Adding the scopes as API permissions can be done via the Azure Portal on the management pane of the service principal.

Note
For the Tenant.Read.All and Tenant.ReadWrite.All scopes Admin consent is needed. This can be applied via the Azure portal.

Screenshot of adding API permissions for the service principal

<h3>Step 5 - Add the service principal to your workspace</h3>
To enable your Azure AD app access artifacts such as reports, dashboards and datasets in the Power BI service, add the service principal entity, or the security group that includes your service principal, as a member or admin to your workspace.

Alternative you can add the service principal as Power BI administrator via Roles and administrators part of your Azure Active Directory management.

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
