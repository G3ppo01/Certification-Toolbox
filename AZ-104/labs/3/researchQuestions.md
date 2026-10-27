# Task 3 Research Questions

## 1. What is the format of an Azure Resource Manager template?

An Azure Resource Manager (ARM) template is a declarative JSON file. It describes the resources Azure should deploy and their configuration. The following example defines a storage account:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "minLength": 3,
      "maxLength": 24
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    }
  },
  "variables": {
    "storageKind": "StorageV2"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2023-05-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[parameters('location')]",
      "kind": "[variables('storageKind')]",
      "sku": {
        "name": "Standard_LRS"
      }
    }
  ],
  "outputs": {
    "accountId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
    }
  }
}
```

The main components are:

| Component | Purpose | Example |
| --- | --- | --- |
| `$schema` | Identifies the JSON schema used to validate the template. The schema shown is for a resource-group deployment. | `.../2019-04-01/deploymentTemplate.json#` |
| `contentVersion` | A version label for the template, chosen by its author. It helps track changes to the template. | `"1.0.0.0"` |
| `parameters` | Values supplied when deploying, so the template can be reused with different inputs. Parameters can have types, defaults, and validation rules. | `storageAccountName` is supplied at deployment time. |
| `variables` | Values or expressions reused in the template. They are calculated by the template and are not supplied as deployment inputs. | `storageKind` is set to `"StorageV2"`. |
| `resources` | The Azure resources to create or update. Each resource identifies its provider type, API version, name, location, and configuration. | `Microsoft.Storage/storageAccounts` |
| `outputs` | Values returned after a successful deployment, such as a resource ID or endpoint. | `accountId` returns the storage account's resource ID. |

`apiProfile`, `functions`, and `definitions` are optional template elements used for more specialized scenarios. Expressions such as `"[parameters('location')]"` let a template derive values or refer to parameters, variables, and resources.

## 2. How do I use an existing ARM template?

An existing template can be deployed again to create or update resources. Before deploying it:

1. Review the template and confirm the resource types, names, locations, and settings are appropriate.
2. Check which parameters are required. Supply them directly in the deployment command or in a parameter file.
3. Ensure the target resource group exists and that your account has permission to deploy the resources.
4. Deploy at the correct scope. The example below is for a resource-group deployment.

For example, save parameter values in `parameters.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "examplestorage123"
    },
    "location": {
      "value": "eastus"
    }
  }
}
```

Deploy with Azure CLI:

```bash
az deployment group create \
  --resource-group myResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```

Or deploy with Azure PowerShell:

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "myResourceGroup" `
  -TemplateFile ".\template.json" `
  -TemplateParameterFile ".\parameters.json"
```

The example storage account name is illustrative; choose a name that meets Azure's naming rules and is globally unique. The `group create` command and `New-AzResourceGroupDeployment` deploy at resource-group scope. ARM templates can also be deployed at subscription, management-group, or tenant scope when the template uses the corresponding schema and deployment command. A deployment is declarative: Resource Manager creates or updates the resources described in the template. Review the template and deployment changes carefully before deploying.

## 3. Compare and contrast ARM templates and Bicep templates

ARM templates and Bicep are both declarative ways to define Azure resources. They use Azure Resource Manager for deployment and can describe the same Azure configurations.

| Aspect | ARM template | Bicep template |
| --- | --- | --- |
| Authoring format | JSON, with braces, quotation marks, and expression strings. | A concise, domain-specific language designed for Azure resources. |
| Readability | Larger and more verbose, especially for nested resources and expressions. | Generally easier to read and maintain. |
| Deployment | Deploy the JSON template directly with Azure CLI, Azure PowerShell, the portal, or an API. | Deploy a `.bicep` file with supported Azure tools; Bicep is compiled to an ARM JSON template for deployment. |
| Parameters and expressions | Defined in JSON and commonly written as ARM expressions, such as `"[parameters('location')]"`. | Declared with Bicep syntax, such as `param location string = resourceGroup().location`. |
| Reuse | Supports nested and linked templates. | Supports modules, which provide a convenient way to organize and reuse deployments. |
| Tooling | JSON editors and ARM template tools can validate and assist with authoring. | The Bicep CLI and VS Code extension provide validation, diagnostics, formatting, and compilation. |
| Conversion | Native deployment format used by Azure Resource Manager. | Can be built into equivalent ARM JSON. Existing ARM JSON can be decompiled to Bicep as a starting point, but generated code should be reviewed. |

**Summary:** ARM JSON is useful when working with existing JSON templates or systems that require that format. For new infrastructure-as-code development, Bicep is often easier to write and maintain while retaining the same Azure deployment capabilities.

## References

- [ARM template structure and syntax](https://learn.microsoft.com/azure/azure-resource-manager/templates/syntax)
- [Deploy ARM templates with Azure CLI](https://learn.microsoft.com/azure/azure-resource-manager/templates/deploy-cli)
- [Deploy ARM templates with Azure PowerShell](https://learn.microsoft.com/azure/azure-resource-manager/templates/deploy-powershell)
- [Bicep overview](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview)
- [Decompile ARM JSON to Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/decompile)