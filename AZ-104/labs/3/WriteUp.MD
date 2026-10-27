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
### Task 1
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

