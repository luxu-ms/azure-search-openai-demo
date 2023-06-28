# ChatGPT + Enterprise data with Azure OpenAI and Cognitive Search
This repo is the just infrastructure part. If you want to deploy application and data, please refer to [repo](https://github.com/luxu-ms/azure-search-openai-demo)

## Prerequisites
Ensure that your machine has installed the following items
- [Python 3+](https://www.python.org/downloads/)
   - **Important**: Python and the pip package manager must be in the path in Windows for the setup scripts to work.
   - **Important**: Ensure you can run `python --version` from console. On Ubuntu, you might need to run `sudo apt install python-is-python3` to link `python` to `python3`.    
- [Node.js](https://nodejs.org/en/download/)
- [Git](https://git-scm.com/downloads)
- [Powershell 7+ (pwsh)](https://github.com/powershell/powershell) - For Windows users only.
   - **Important**: Ensure you can run `pwsh.exe` from a PowerShell command. If this fails, you likely need to upgrade PowerShell.

>NOTE: Your Azure Account must have `Microsoft.Authorization/roleAssignments/write` permissions, such as [User Access Administrator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#owner). 

- [Dev Center](https://learn.microsoft.com/en-us/azure/deployment-environments/quickstart-create-and-configure-devcenter), [Project](https://learn.microsoft.com/en-us/azure/deployment-environments/quickstart-create-and-configure-projects) and [Catalog](https://learn.microsoft.com/en-us/azure/deployment-environments/how-to-configure-catalog)
   - **Important**: Ensure the user is assigned role "Deployment Environments User" to the project
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) and [Azure CLI extension for Dev Center](https://learn.microsoft.com/en-us/azure/deployment-environments/how-to-install-devcenter-cli-extension)
- Clone the application and data [repo](https://github.com/luxu-ms/azure-search-openai-demo)

## How to setup
1. Use [Dev Portal](https://devportal.microsoft.com/) to deploy the infra 
* Click "+New" -> "New environment"
* Give a name for the environment name (e.g. dev1)
* Select the environment type (e.g. Dev/Test)
* Select catalog item (e.g. OpenAISearch)
* Click "Next"
* Input the required parameters (e.g. "environmentName" is dev1, "principalId" is your user's Object ID which can be found in the Azure Active Directory's users)
* Click "Create"

2. In the Dev Box or the environment you have prepared, in the PowerShell,use "az login" to login
3. Run the script "deploy.ps1" in the PowerShell by the command below:
```
.\deploy.ps1
```
>Note: The parameters that the deploy.ps1 required are the resources that we use Azure Deployment Environments to provision in step 1.