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
Azure:
An Enterprise Application registration is needed to create a service principal which can be used to connect to services and perform tasks unattended and more securely than a user account.
<ul>
<li>This can be done in the Azure portal or PowerShell</li>
<li>as shown in this this MS article <a href="https://learn.microsoft.com/en-us/power-bi/developer/embedded/embed-service-principal#create-an-azure-ad-app-by-using-powershell">Embed Power BI content</a></li>
</ul>

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
