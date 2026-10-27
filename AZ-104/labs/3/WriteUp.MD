# Lab 03 - Manage Azure resources by using Azure Resource Manager Templates
## Intro
In this lab, you learn how to automate resource deployments. You learn about Azure Resource Manager templates and Bicep templates. You learn about the different ways of deploying the templates.

This lab requires an Azure subscription. Your subscription type may affect the availability of features in this lab. You may change the region, but the steps are written using East US.
## Scenario
Your team wants to look at ways to automate and simplify resource deployments. Your organization is looking for ways to reduce administrative overhead, reduce human error and increase consistency.
## Tasks
- Task 1: Create an Azure Resource Manager template.
- Task 2: Edit an Azure Resource Manager template and redeploy the template.
- Task 3: Configure the Cloud Shell and deploy a template with Azure PowerShell.
- Task 4: Deploy a template with the CLI.
- Task 5: Deploy a resource by using Azure Bicep.

## Write up
### Task 1 Create an Azure Resource Manager template.
- Created an azure disk via gui with the following parameters:

| Setting | Value |
| --- | --- |
| Subscription | *your subscription* |
| Resource Group | `az104-rg3` (If necessary, select **Create new**.) |
| Disk name | `az104-disk1` |
| Region | **East US** |
| Availability zone | **No infrastructure redundancy required** |
| Source type | **None** |
| Performance | **Standard HDD** (change size) |
| Size | **32 Gib** |

- Go to the created ressource, and in the "Automation" blade, export the template

ARM Json template:
```Json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "disks_az104_disk1_name": {
            "defaultValue": "az104-disk1",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Compute/disks",
            "apiVersion": "2026-03-02",
            "name": "[parameters('disks_az104_disk1_name')]",
            "location": "eastus",
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "properties": {
                "creationData": {
                    "createOption": "Empty"
                },
                "diskSizeGB": 32,
                "diskIOPSReadWrite": 500,
                "diskMBpsReadWrite": 60,
                "encryption": {
                    "type": "EncryptionAtRestWithPlatformKey"
                },
                "networkAccessPolicy": "AllowAll",
                "publicNetworkAccess": "Enabled",
                "dataAccessAuthMode": "None"
            }
        }
    ]
}
```
Bicep template: 
```Json
param disks_az104_disk1_name string = 'az104-disk1'

resource disks_az104_disk1_name_resource 'Microsoft.Compute/disks@2026-03-02' = {
  name: disks_az104_disk1_name
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 32
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    networkAccessPolicy: 'AllowAll'
    publicNetworkAccess: 'Enabled'
    dataAccessAuthMode: 'None'
  }
}

```
- Wrote a powershell script that does the same: ./scripts/task1.ps1

### Task 2 Edit an Azure Resource Manager template and redeploy the template.
- Created a new disk from the exported ARM Json template in the GUI
1. Search and select the "Deploy from a custom template" azure service
2. Build your own template editor --> Load the template.json file
3. Adjust some parameters (DiskName should be a new name)
4. Review and create

### Task 3 Deploy a template with PowerShell
- It is possible to complete this task via the Cloud Shell. Howewer, I'll do it from VSCode
1. Mail pwsh cmdlet
```Powershell
New-AzResourceGroupDeployment -ResourceGroupName az104-rg3 -TemplateFile $template_task3 -TemplateParameterFile $parameters_task3
```
### Task 4: Deploy a template with Azure CLI
For this task, I used Azure CLI in Bash Cloud Shell.

1. **Open Cloud Shell** and select **Bash**.
2. **Check and select the target subscription:**

```bash
az account show
az account set --subscription "<subscription-ID>"
```

3. **Prepare the template files.** Edit the ARM template and parameter file in VS Code, then upload both files to Cloud Shell.
4. **Deploy the template** to the resource group. Then list its disks to verify the deployment:

```bash
az deployment group create --resource-group az104-rg3 --template-file template_task4.json --parameters parameters_task4.json

az disk list --resource-group az104-rg3 --output table
```
### Task 5 Deploy a resource by using Azure Bicep (CLI)
1. Download the bicep file from the GUI
2. Changed the disk name and SKU name (StandardSSD_LRS)
3. Upload the file to the cloud shell
4. Deploy and check:
```bash
az deployment group create --resource-group az104-rg3 --template-file task5_template.bicep

az disk list --resource-group az104-rg3 --output table
```
