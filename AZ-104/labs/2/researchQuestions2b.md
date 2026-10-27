# Microsoft Azure Administration: Resource Locks, Azure Policy, RBAC, Compliance, and Resource Tags

This guide covers the Azure PowerShell and Azure CLI commands for managing resource locks, the differences between Azure Policy and Azure RBAC, policy enforcement and remediation, and reporting on Azure resources by tag.

## 1. Azure PowerShell and CLI commands for adding and deleting resource locks on a resource group

Azure resource locks help protect resources against accidental deletion or modification. Locks can be applied at the subscription, resource group, or individual resource level.

### Types of resource locks

| Lock type | Description | Delete resource? | Modify resource? |
| --- | --- | --- | --- |
| `CanNotDelete` | Protects resources from accidental deletion. | No | Yes |
| `ReadOnly` | Allows read operations only. | No | No |

Locks inherited from a parent scope can also affect resources within a resource group. Removing a lock requires appropriate permissions, such as the `Microsoft.Authorization/locks/delete` permission.

### A. Azure PowerShell

First, select the appropriate subscription and define the resource group.

```powershell
# Select the subscription
Set-AzContext -SubscriptionId "<subscription-id>"

# Define the resource group
$resourceGroup = "rg-production"
```

Add a `CanNotDelete` lock:

```powershell
New-AzResourceLock `
    -LockName "Prevent-Deletion" `
    -LockLevel CanNotDelete `
    -ResourceGroupName $resourceGroup `
    -LockNotes "Protect production resources from deletion" `
    -Force
```

Add a `ReadOnly` lock:

```powershell
New-AzResourceLock `
    -LockName "ReadOnly-Lock" `
    -LockLevel ReadOnly `
    -ResourceGroupName $resourceGroup `
    -Force
```

List locks on the resource group and its resources:

```powershell
Get-AzResourceLock -ResourceGroupName $resourceGroup -AtScope
```

Delete a specific lock:

```powershell
Remove-AzResourceLock `
    -LockName "Prevent-Deletion" `
    -ResourceGroupName $resourceGroup `
    -Force
```

To remove all locks directly associated with the resource group, use care with the following command:

```powershell
Get-AzResourceLock -ResourceGroupName $resourceGroup |
    Remove-AzResourceLock -Force
```

Review the results first if you need to preserve some locks. Also check for inherited locks at higher scopes.

### B. Azure CLI

Define the resource group:

```bash
RG="rg-production"
```

Add a `CanNotDelete` lock:

```bash
az lock create \
  --name "Prevent-Deletion" \
  --lock-type CanNotDelete \
  --resource-group "$RG" \
  --notes "Protect production resources from deletion"
```

Add a `ReadOnly` lock:

```bash
az lock create \
  --name "ReadOnly-Lock" \
  --lock-type ReadOnly \
  --resource-group "$RG"
```

List locks:

```bash
az lock list --resource-group "$RG" --output table
```

To inspect locks throughout the resource group hierarchy, including resource-level locks:

```bash
az lock list --resource-group "$RG" --namespace Microsoft.Authorization
```

Delete a specific lock:

```bash
az lock delete \
  --name "Prevent-Deletion" \
  --resource-group "$RG"
```

Delete all locks directly associated with the resource group:

```bash
az lock list --resource-group "$RG" \
  --query "[].name" -o tsv |
while IFS= read -r lock; do
  [ -z "$lock" ] || az lock delete \
    --name "$lock" \
    --resource-group "$RG"
done
```

The bulk-delete example is intended for Bash-compatible shells and should be reviewed before execution.

Important: A `ReadOnly` lock can prevent operations that appear to be read-only at the resource level if the operation requires a write operation against a locked scope. For example, listing keys or performing certain control-plane operations may be affected. A lock is not a substitute for access control or backups.

Official references: [Azure resource locks](<https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?utm_source=chatgpt.com>), [PowerShell `New-AzResourceLock`](<https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcelock?utm_source=chatgpt.com>), and [Azure CLI lock commands](<https://learn.microsoft.com/en-us/cli/azure/resource/lock?utm_source=chatgpt.com>).

## 2. Differences between Azure Policy and Azure RBAC

Azure Policy and Azure Role-Based Access Control (RBAC) solve different governance problems.

- Azure Policy determines whether resource configurations comply with organizational rules.
- Azure RBAC determines who can perform which operations on Azure resources.

A user can have permission to create a resource through RBAC, but Azure Policy can still deny the creation if the proposed configuration violates a policy.


### Comparison table

| Feature | Azure Policy | Azure RBAC |
| --- | --- | --- |
| Primary purpose | Enforce organizational standards and compliance | Control user, group, service principal, and managed identity permissions |
| Main question | Is this resource configuration allowed or compliant? | Who can perform this action? |
| Based on | Resource properties and policy rules | Security principal, role, scope, and allowed actions |
| Main components | Policy definitions, initiatives, assignments, exemptions | Role definitions, role assignments, security principals |
| Scope | Management group, subscription, resource group, resource | Management group, subscription, resource group, resource |
| Enforcement | Audit, deny, modify, deploy resources, and other policy effects | Allow or deny access based on effective permissions |
| Existing resources | Can evaluate compliance and remediate supported configurations | Controls access but does not fix resource configuration |
| Example | Require every storage account to use secure transport | Allow the operations team to manage storage accounts |
| Typical roles | Resource Policy Contributor for policy administration | Owner, Contributor, Reader, custom roles |

### Example 1: Azure Policy — require a tag

Suppose every resource must have an `Environment` tag.

A policy using the `deny` effect can prevent the creation or update of a resource that lacks the required tag.

Example policy rule:

```json
{
  "if": {
    "field": "tags['Environment']",
    "exists": "false"
  },
  "then": {
    "effect": "deny"
  }
}
```

This is the rule portion of an Azure Policy definition, not a complete deployable definition. It must be placed in a policy definition and assigned to the appropriate scope.

Result: A user with sufficient RBAC permissions still cannot create or update a resource in a way that violates the assigned policy.

### Example 2: Azure RBAC — allow resource management

Suppose the operations team needs to manage virtual machines in a resource group.

Assign the built-in `Virtual Machine Contributor` role at that resource group.

```bash
az role assignment create \
  --assignee "<user-or-group-object-id>" \
  --role "Virtual Machine Contributor" \
  --resource-group "rg-production"
```

Result: The assigned principal receives the VM management permissions defined by that role, subject to other applicable authorization controls and policy restrictions.

### Example 3: Use Policy and RBAC together

Consider a production subscription with the following requirements:

1. Only the operations team can manage virtual machines.
2. Every resource must have an `Environment` tag.
3. Storage accounts must use secure transport.
4. Production resources must be protected from accidental deletion.

Use the following controls:

| Requirement | Azure control |
| --- | --- |
| Restrict VM management to the operations team | Azure RBAC |
| Require the `Environment` tag | Azure Policy |
| Require secure storage transport | Azure Policy |
| Prevent accidental deletion | Azure resource locks |
| Review compliance centrally | Azure Policy compliance reporting |

Best practice: Use RBAC for authorization, Azure Policy for governance, and resource locks for operational protection. These controls complement one another rather than replace one another.

## 3. Steps to enforce Azure Policy and remediate non-compliant resources

Azure Policy enforcement generally involves defining the rule, assigning it to a scope, evaluating resources, and remediating supported non-compliant resources.

### Step 1: Select or create a policy definition

In the Azure portal:

1. Navigate to Policy.
2. Select Definitions.
3. Search for an existing built-in policy or create a custom definition.
4. Review its parameters, policy rule, and effect.

Common effects include:

| Effect | Purpose |
| --- | --- |
| `Audit` | Report non-compliant configurations without blocking them |
| `Deny` | Block resource creation or updates that violate the policy |
| `Modify` | Add or update supported resource properties or tags |
| `DeployIfNotExists` | Deploy a related resource or configuration when a required condition is missing |
| `AuditIfNotExists` | Audit whether a related resource or configuration exists |
| `Disabled` | Disable evaluation enforcement for that definition assignment |

The `Modify` and `DeployIfNotExists` effects can support remediation of existing resources. However, remediation is not automatically available for every policy effect or resource property.



### Step 2: Assign the policy

1. Open Policy → Assignments.
2. Select Assign policy.
3. Choose the scope: management group, subscription, or resource group.
4. Select the policy definition.
5. Configure parameters and exclusions, if necessary.
6. Review the enforcement mode and identity settings.
7. Create the assignment.

For an initial rollout, consider starting with `Audit`, checking the impact, and then moving to `Deny` or a remediation-capable effect where appropriate.

### Step 3: Evaluate compliance

After assignment, Azure Policy evaluates applicable resources. Initial results can take several minutes or longer to appear.

In the portal:

1. Open Policy → Compliance.
2. Select the policy assignment.
3. Review compliant and non-compliant resources.
4. Open individual resources to investigate the reasons for non-compliance.

The compliance dashboard provides an aggregated view across the assigned scope.



### Step 4: Remediate non-compliant resources

The remediation approach depends on the policy effect.

- `Modify`: Create a remediation task to apply supported property or tag changes.
- `DeployIfNotExists`: Create a remediation task to deploy the required related configuration or resource.
- `Deny`: Correct existing resources manually or with an appropriate deployment or automation process. A deny policy itself does not repair existing resources.
- `Audit`: Investigate and fix the configuration manually or with automation.

For `Modify` and `DeployIfNotExists`, the policy assignment must have a managed identity with the necessary RBAC permissions to carry out the remediation.



### Step 5: Verify remediation

After the remediation task finishes:

1. Review the task's deployment status and any errors.
2. Recheck the resource configuration.
3. Refresh or trigger a policy compliance evaluation as appropriate.
4. Confirm that the resource is reported as compliant.

A successful remediation task does not guarantee that every resource is compliant; some resources may fail because of permissions, unsupported properties, deployment errors, or other constraints.

### Remediation commands

Once the policy is assigned and the managed identity has the required permissions, remediation can also be started through the CLI or PowerShell.

Azure CLI:

```bash
# Replace with your actual policy assignment name or resource ID
ASSIGNMENT="require-environment-tag"
RG="rg-production"

az policy remediation create \
  --name "remediate-environment-tag" \
  --policy-assignment "$ASSIGNMENT" \
  --resource-group "$RG"
```

Azure PowerShell:

```powershell
$assignmentId = "/subscriptions/<subscription-id>/providers/Microsoft.Authorization/policyAssignments/<assignment-name>"

Start-AzPolicyRemediation `
    -Name "remediate-environment-tag" `
    -PolicyAssignmentId $assignmentId `
    -ResourceGroupName "rg-production"
```

These commands create remediation tasks for eligible non-compliant resources at the specified scope. Use the actual assignment ID or name, and ensure that the assigned policy supports remediation.



To trigger a compliance scan with PowerShell:

```powershell
Start-AzPolicyComplianceScan `
    -ResourceGroupName "rg-production"
```

For a subscription-wide scan:

```powershell
Start-AzPolicyComplianceScan
```

A compliance scan evaluates resources; it does not itself repair them. Remediation and subsequent compliance verification are separate steps.

## 4. How to get a report of Azure resources with specific tags

You can retrieve Azure resources by tag using Azure CLI, Azure PowerShell, or Azure Resource Graph. For reporting across many resource groups or subscriptions, Azure Resource Graph is generally the most flexible option.



### Option A: Azure CLI

List resources with a specific tag name and value:

```bash
az resource list \
  --tag Environment=Production \
  --query "[].{Name:name, Type:type, ResourceGroup:resourceGroup, Location:location}" \
  --output table
```

List resources with a tag name regardless of its value:

```bash
az resource list \
  --tag Environment \
  --output table
```

Export the results to CSV:

```bash
az resource list \
  --tag Environment=Production \
  --query "[].{Name:name, Type:type, ResourceGroup:resourceGroup, Location:location}" \
  --output tsv > production-resources.tsv
```

The final command exports tab-separated data despite the filename being `.tsv`. To generate a CSV file, use a PowerShell export or convert the output with a CSV-capable tool.

### Option B: Azure PowerShell

```powershell
$resources = Get-AzResource |
    Where-Object {
        $_.Tags -and
        $_.Tags["Environment"] -eq "Production"
    }

$resources |
    Select-Object Name, ResourceType, ResourceGroupName, Location |
    Export-Csv -Path ".\production-resources.csv" -NoTypeInformation
```

To find resources with an `Environment` tag regardless of its value:

```powershell
Get-AzResource |
    Where-Object {
        $_.Tags -and
        $_.Tags.ContainsKey("Environment")
    } |
    Select-Object Name, ResourceType, ResourceGroupName, Location
```

These examples query resources visible in the current Azure context and subscription. For multiple subscriptions, select each subscription or use Azure Resource Graph.

### Option C: Azure Resource Graph — recommended for reporting

Azure Resource Graph lets you query resource metadata across accessible subscriptions using Kusto Query Language (KQL).

In the Azure portal:

1. Search for Resource Graph Explorer.
2. Enter the query.
3. Select the relevant subscriptions.
4. Run the query.
5. Export the results for reporting.

Example 1: Find resources tagged `Environment = Production`

```kusto
Resources
| where tags["Environment"] =~ "Production"
| project name, type, resourceGroup, subscriptionId, location, tags
| order by resourceGroup asc
```

Example 2: Find resources with a specific tag key, regardless of value

```kusto
Resources
| where isnotempty(tags["CostCenter"])
| project name, type, resourceGroup, subscriptionId, location,
          CostCenter = tostring(tags["CostCenter"])
| order by CostCenter asc
```

Example 3: Find resources missing a required tag

```kusto
Resources
| where not(tags has "Environment")
| project name, type, resourceGroup, subscriptionId, location
| order by resourceGroup asc
```

Example 4: Count production resources by resource group

```kusto
Resources
| where tags["Environment"] =~ "Production"
| summarize ResourceCount = count() by resourceGroup
| order by ResourceCount desc
```

Example 5: Query through Azure CLI

First, sign in and ensure the relevant subscriptions are accessible. Install the Resource Graph extension if prompted.

```bash
az graph query -q "
Resources
| where tags['Environment'] =~ 'Production'
| project name, type, resourceGroup, subscriptionId, location, tags
" --output table
```

For a more portable export, request JSON and convert it to CSV with a suitable tool. Resource Graph queries can return paginated results, so large reports may require handling continuation tokens or querying in batches.



### Option D: Generate a CSV report using Azure PowerShell

For a practical report that can be opened in Excel, use the following script:

```powershell
Connect-AzAccount

$results = Get-AzResource |
    Where-Object {
        $_.Tags -and
        $_.Tags["Environment"] -eq "Production"
    } |
    Select-Object Name,
                  ResourceType,
                  ResourceGroupName,
                  SubscriptionId,
                  Location,
                  @{Name="Environment"; Expression={$_.Tags["Environment"]}},
                  @{Name="Owner"; Expression={$_.Tags["Owner"]}},
                  @{Name="CostCenter"; Expression={$_.Tags["CostCenter"]}}

$results | Export-Csv `
    -Path ".\Azure-Production-Resources.csv" `
    -NoTypeInformation `
    -Encoding UTF8
```

The report contains resource names, types, resource groups, subscription IDs, locations, and selected tag values. If you manage multiple subscriptions, iterate through the subscriptions or use Azure Resource Graph to consolidate the report.

### Important considerations

- Tag names and values are strings; establish consistent naming and capitalization across your organization.
- Resources that do not support tags cannot be reported using tag filters in the same way as taggable resources.
- A tag on a resource group is not automatically a tag on every resource within that group.
- Azure Resource Graph is useful for cross-subscription reporting, but the query only covers subscriptions and resources within your accessible scope.
- If you need to enforce required tags, use Azure Policy in addition to reporting. A report identifies gaps; a policy can prevent new violations or remediate supported existing resources.

## Official Microsoft Learn references

1. [Lock your Azure resources to protect your infrastructure](<https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?utm_source=chatgpt.com>)
2. [Overview of Azure Policy](<https://learn.microsoft.com/en-us/azure/governance/policy/overview?utm_source=chatgpt.com>)
3. [Remediate non-compliant resources with Azure Policy](<https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?utm_source=chatgpt.com>)
4. [Azure Policy compliance states](<https://learn.microsoft.com/en-us/azure/governance/policy/concepts/compliance-states?utm_source=chatgpt.com>)
5. [Tag Azure resources with Azure CLI](<https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources-cli?utm_source=chatgpt.com>)
6. [Azure Resource Graph sample queries](<https://learn.microsoft.com/en-us/azure/governance/resource-graph/samples/samples-by-category?utm_source=chatgpt.com>)