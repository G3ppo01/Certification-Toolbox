# Aggregated Certification Notes

**Generated:** 2026-11-23 10:43:04
**Source directory:** `/public/Certification-Toolbox/AZ-104`
**Number of sources:** 11

## How to use this document

This document combines multiple Markdown note files into one source.
Each section is labeled with its original relative path. Treat each source
section as one study note and preserve the source label when citing information.

## Source index

1. `labs/1/researchQuestions.md`
2. `labs/2/researchQuestions2a.md`
3. `labs/2/researchQuestions2b.md`
4. `labs/3/researchQuestions.md`
5. `labs/3/WriteUp.MD`
6. `labs/4/WriteUp.MD`
7. `labs/5/WriteUp.MD`
8. `labs/7/WriteUp.MD`
9. `labs/Template/WriteUp.MD`
10. `Notes/Compute/ComputeNotes.md`
11. `plan.md`



------------------------------------------------------------------------


## Source 1: labs/1/researchQuestions.md

> Original file: `labs/1/researchQuestions.md`

# Microsoft Entra ID: User and Group Management Guide

## 1. Create a security group named `IT Admins` using PowerShell and Azure CLI

A security group in Microsoft Entra ID can be used to assign application access, permissions, and other resources to a collection of users. The following commands create a security group named `IT Admins`.

### Option A: PowerShell

Use the Microsoft Graph PowerShell SDK, which is the recommended approach for managing Microsoft Entra ID.

```powershell
# Install the Microsoft Graph PowerShell SDK if needed
Install-Module Microsoft.Graph -Scope CurrentUser

# Connect with permission to manage groups
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Create the security group
New-MgGroup `
    -DisplayName "IT Admins" `
    -Description "IT administrators security group" `
    -MailEnabled:$false `
    -MailNickname "ITAdmins" `
    -SecurityEnabled:$true

# Verify the group
Get-MgGroup -Filter "displayName eq 'IT Admins'"
```

Official command reference: [New-MgGroup — Microsoft Learn](<https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/new-mggroup?utm_source=chatgpt.com>)

Notes:

- An administrator may need to grant consent to the `Group.ReadWrite.All` permission.
- The group created by this command is a security group, not a Microsoft 365 group.
- Creating the group does not grant its members privileged administrator roles. Assign administrative roles separately, using least privilege.

### Option B: Azure CLI

Sign in to the correct Microsoft Entra tenant, then run:

```bash
# Sign in to Azure
az login

# Create the security group
az ad group create \
  --display-name "IT Admins" \
  --mail-nickname "ITAdmins" \
  --description "IT administrators security group"

# Verify the group
az ad group show \
  --group "IT Admins" \
  --query "{name:displayName,id:id,securityEnabled:securityEnabled}"
```

Official command reference: [az ad group — Microsoft Learn](<https://learn.microsoft.com/en-us/cli/azure/ad/group?view=azure-cli-latest&utm_source=chatgpt.com>)

The CLI command creates a directory group using the specified display name and mail nickname. For automation, verify the resulting group's `securityEnabled` property before using it for access control.

## 2. Step-by-step strategy for managing users and groups in Microsoft Entra ID

A reliable management strategy should cover the full identity lifecycle: onboarding, access assignment, ongoing reviews, and offboarding.

### Step 1: Plan identities and access

Identify employees, contractors, partners, applications, and required access. Decide whether each person needs an internal account or external guest access.

### Step 2: Create or invite users

Create internal member accounts for employees and invite external users for collaboration. Assign the appropriate username, authentication method, and license.

### Step 3: Organize users into groups

Create security groups based on job function, department, application, or resource. Assign group owners and use dynamic membership where appropriate.

### Step 4: Apply security controls

Enforce multifactor authentication (MFA), use Conditional Access policies, apply least privilege, and grant administrative roles only when required. Use privileged identity management where licensed and appropriate.

### Step 5: Monitor and review

Review group membership, inactive accounts, guest access, sign-in logs, audit logs, and access assignments. Remove unnecessary access promptly.

### Step 6: Offboard users

Disable or otherwise appropriately deprovision accounts, revoke sessions, remove access and licenses when appropriate, transfer ownership of business resources, and retain required audit records.

### Recommended administrative practices

- Use role-based access control (RBAC) and assign the minimum permissions needed.
- Assign application access to groups rather than managing individual assignments wherever possible.
- Use a documented naming convention, such as `SG-IT-Admins-Prod`.
- Establish an approval process for privileged groups and require periodic membership reviews.
- Automate provisioning and deprovisioning through HR-driven workflows or identity lifecycle tools where appropriate.
- Treat external access as time-bound when possible, and review guest accounts regularly.

Official references:

- [Microsoft Entra user and group management](<https://learn.microsoft.com/en-us/entra/identity/users/?utm_source=chatgpt.com>)
- [How to manage groups](<https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/how-to-manage-groups?utm_source=chatgpt.com>)
- [Configure external collaboration](<https://learn.microsoft.com/en-us/entra/external-id/external-collaboration-settings-configure?utm_source=chatgpt.com>)

## 3. Steps in the Azure portal to bulk-create users and groups

Use the Microsoft Entra admin center at [entra.microsoft.com](<https://entra.microsoft.com/?utm_source=chatgpt.com>). The process differs for creating user accounts, creating groups, and importing group members.

### A. Bulk-create internal users

1. Sign in to the Microsoft Entra admin center with at least the User Administrator role.
2. Navigate to Entra ID → Users → Bulk create.
3. Select Download to obtain the CSV template.
4. Open the CSV file and add one user per row. Preserve the exact column headers. The required fields are display name, user principal name, and initial password.
5. Save the file as CSV and upload it under Upload your CSV file.
6. Select Submit after validation succeeds.
7. Check the bulk operation results, download any error report, and verify the accounts under Users → All users.

**Important:** This workflow creates internal member accounts and does not automatically send invitation emails. Handle initial credentials securely. To onboard external users, use the guest invitation workflow instead.

Official guide: [Bulk create users in Microsoft Entra ID](<https://learn.microsoft.com/en-us/entra/identity/users/users-bulk-add?utm_source=chatgpt.com>)

### B. Create groups

For a single group, navigate to Entra ID → Groups → All groups → New group, select Security as the group type, enter the group name and description, configure membership type, and select Create.

For example, to create the `IT Admins` security group, choose:

- Group type: Security
- Group name: `IT Admins`
- Membership type: Assigned (for manually managed membership) or Dynamic User (if using rules and eligible licensing)

If you need to create many groups, check the current bulk operations capabilities available in your tenant. Do not assume the standard New group page provides CSV-based bulk creation for every tenant or group scenario.

Official reference: [Bulk operations in Microsoft Entra ID](<https://learn.microsoft.com/en-us/entra/fundamentals/bulk-operations?utm_source=chatgpt.com>)

### C. Bulk-add users to an existing group

1. Go to Entra ID → Groups → All groups.
2. Open the target group, such as `IT Admins`, and select Members.
3. Select Bulk operations → Import members.
4. Download the CSV template and add one member per row using their user principal name (UPN) or object ID.
5. Upload the CSV, correct validation errors, and select Submit.
6. Review the operation results and verify that the expected members appear in the group.

The template's exact column headers must be preserved. The current documentation also specifies at least two member entries for this bulk import operation.

Official guide: [Bulk add group members by uploading a CSV file](<https://learn.microsoft.com/en-us/entra/identity/users/groups-bulk-import-members?utm_source=chatgpt.com>)

## 4. Comparison of internal and external Microsoft Entra ID user accounts

The most important distinction is that internal versus external describes the user's identity and authentication relationship, while member versus guest (`UserType`) describes the user's access classification in the tenant. These are related but not interchangeable concepts.

| Characteristic | Internal user account | External user account |
| --- | --- | --- |
| Typical purpose | Employees and organizational workforce | Partners, suppliers, contractors, and collaborators |
| Identity source | The user's home account is managed in the organization's tenant | The user generally authenticates through an external organization or identity provider |
| Authentication | Typically uses credentials and authentication methods managed by the home tenant | Typically uses the user's external identity provider; other supported invitation authentication methods may apply |
| Common user type | Member | Guest |
| Default permissions | Member-level permissions, subject to assigned roles and policies | Often guest-level permissions, subject to tenant settings and assignments |
| Account provisioning | Created directly or provisioned through synchronization or automation | Commonly invited through Microsoft Entra B2B collaboration |
| Password management | Usually managed by the home organization | Usually managed by the external identity provider |
| MFA and Conditional Access | Governed by the organization's applicable policies | Governed by applicable resource-tenant and cross-tenant authentication policies |
| Licensing | Depends on the services and features assigned | Depends on services used, licensing rules, and applicable collaboration arrangements |
| Offboarding | Disable or deprovision the account and remove access as required | Remove or revoke external access, or remove the guest account when no longer needed |

### The four possible combinations

Microsoft Entra ID can contain four combinations of internal/external and member/guest:

| Combination | Example | Meaning |
| --- | --- | --- |
| Internal member | Employee | Authenticates through the home tenant and has member-level access. |
| Internal guest | Legacy internal account for a nonemployee | Has locally managed credentials but guest-level access. |
| External guest | Supplier invited for collaboration | Authenticates externally and has guest-level access. |
| External member | Employee accessing another tenant in a multitenant organization | Authenticates externally but has member-level access in the resource tenant. |

An external account does not automatically have to be a guest. For example, an employee from a second tenant might be an external member when the organization requires member-level access across multiple tenants. Changing `UserType` alone does not change where the user authenticates.

Official reference: [B2B guest user properties — Microsoft Learn](<https://learn.microsoft.com/en-us/entra/external-id/user-properties?utm_source=chatgpt.com>)

## Summary

For an IT administration environment, the recommended approach is to create the `IT Admins` security group, manage its membership through approved administrative workflows, and use groups to organize access rather than assigning permissions directly to individual users whenever practical. Combine that approach with MFA, least privilege, regular access reviews, and a documented offboarding process.

The official Microsoft Learn links above provide the command syntax, portal procedures, and identity-management concepts needed to implement these practices.



------------------------------------------------------------------------


## Source 2: labs/2/researchQuestions2a.md

> Original file: `labs/2/researchQuestions2a.md`

# Azure Subscription Management and RBAC Guide

This guide covers Azure subscription information commands using PowerShell and Azure CLI, the JSON format for Azure RBAC custom roles, the steps to create a custom role, and the differences between Azure RBAC roles and Microsoft Entra ID roles.

## 1. PowerShell commands for Azure subscription information

Sign in to Azure using Connect-AzAccount. Install the Az PowerShell module if necessary.

| PowerShell command | Explanation |
| --- | --- |
| `Connect-AzAccount` | Authenticates the user and establishes an Azure session. |
| `Get-AzSubscription` | Lists subscriptions accessible to the signed-in account, including subscription names, IDs, and tenant information. |
| `Get-AzContext` | Displays the current Azure context, including the selected subscription and tenant. |
| `Set-AzContext -SubscriptionId "<subscription-id>"` | Switches the current context to the specified subscription. |
| `Get-AzSubscription -SubscriptionId "<subscription-id>"` | Retrieves information about a specific subscription. |
| `Get-AzResourceGroup` | Lists resource groups in the currently selected subscription. |
| `Get-AzRoleAssignment` | Lists RBAC role assignments visible to the account at the applicable scope, subject to permissions. |
| `Get-AzTenant` | Retrieves tenant information available to the authenticated account. |

Official references:

- `Get-AzSubscription`
- `Get-AzContext`
- `Get-AzResourceGroup`

## 2. Azure CLI commands for Azure subscription information

Sign in using az login. The following commands retrieve subscription information and help manage the active subscription context.

| Azure CLI command | Explanation |
| --- | --- |
| `az login` | Authenticates the user to Azure and loads accessible subscription information. |
| `az account list --output table` | Lists accessible subscriptions in a readable table. Disabled subscriptions are excluded by default. |
| `az account list --all --output json` | Lists subscriptions across the current cloud, including subscriptions that are not enabled. |
| `az account show --output json` | Displays details of the currently selected subscription, including its ID, tenant ID, name, and state. |
| `az account set --subscription "<subscription-id>"` | Sets the specified subscription as the active subscription for subsequent commands. |
| `az account list-locations --output table` | Lists Azure regions available to the current subscription. |
| `az group list --output table` | Lists resource groups in the active subscription. |
| `az role assignment list --all --output table` | Lists RBAC role assignments visible to the caller across accessible scopes, subject to permissions. |
| `az account tenant list --output table` | Lists tenants associated with the authenticated account. |

### Practical example

```bash
# Sign in to Azure
az login

# List subscriptions
az account list --output table

# Select a subscription
az account set --subscription "<subscription-id>"

# Verify the active subscription
az account show --output table

# List resource groups
az group list --output table
```

Replace <subscription-id> with the actual subscription ID.

Official references:

- Azure CLI account commands
- Manage Azure subscriptions using Azure CLI

## 3. What is the format of an Azure RBAC JSON file?

An Azure custom role definition is a JSON document that describes the role's name, description, permissions, and assignable scopes.

Azure CLI and Azure PowerShell support a role-definition JSON structure with properties such as Name, Description, Actions, and AssignableScopes. The Azure portal and REST API also support a format with a properties object containing fields such as roleName, description, permissions, and assignableScopes.

### Example custom role JSON

Save the following content as CustomReaderRole.json. Replace the example subscription ID with your own.

```json
{
  "Name": "Custom Resource Reader",
  "Description": "Read resource information without modifying resources",
  "Actions": [
    "*/read"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/00000000-0000-0000-0000-000000000000"
  ]
}
```

Security note: The wildcard */read is broad. For production environments, specify only the resource-provider read operations required by the role.

### JSON properties

| Property | Explanation |
| --- | --- |
| `Name` / `roleName` | Defines the display name of the custom role. |
| `Description` / `description` | Describes the role's purpose. |
| `Actions` / `actions` | Defines permitted control-plane operations, such as reading or modifying Azure resources. |
| `NotActions` / `notActions` | Excludes operations from the role's `Actions` set. It is not an explicit deny rule and does not override permissions granted by other roles. |
| `DataActions` / `dataActions` | Defines permitted data-plane operations, such as accessing data inside supported Azure services. |
| `NotDataActions` / `notDataActions` | Excludes specified operations from the role's `DataActions` set. |
| `AssignableScopes` / `assignableScopes` | Defines the management groups, subscriptions, or resource groups where the role is available for assignment. |

Official reference: Create or update Azure custom roles.

## 4. Basic steps for creating a custom Azure RBAC role

Custom roles allow administrators to define specific permissions when built-in roles do not meet organizational requirements.

### Option A: Create a custom role in the Azure portal

1. Sign in to the Azure portal.
2. Navigate to the target management group, subscription, or resource group.
3. Open **Access control (IAM)**.
4. Select **Add → Add custom role**.
5. Choose an appropriate starting option, such as **Start from scratch**, **Clone a role**, or **Start from JSON**, depending on the available portal workflow.
6. Enter the role name and description.
7. Configure the required control-plane `Actions` and, if necessary, data-plane `DataActions`.
8. Exclude unnecessary operations and avoid broad wildcard permissions.
9. Configure `AssignableScopes` using the narrowest appropriate scope.
10. Review the configuration and create the role.
11. Open the appropriate scope's **Access control (IAM)** page.
12. Select **Add role assignment**, choose the custom role, select the user, group, or service principal, and complete the assignment.
13. Test the assigned permissions and verify that unauthorized operations remain unavailable.

### Option B: Create a custom role using Azure CLI

After saving the JSON definition as CustomReaderRole.json, run:

```bash
# Sign in to Azure
az login

# Select the target subscription
az account set --subscription "<subscription-id>"

# Create the custom role
az role definition create \
  --role-definition @CustomReaderRole.json

# Verify the role definition
az role definition list \
  --name "Custom Resource Reader" \
  --output json
```

The identity executing these commands must have the required permissions to create custom role definitions at the relevant scope.

The AssignableScopes property determines where the role is available for assignment. It does not itself grant access to resources.

### Best practices

- Apply the principle of least privilege.
- Avoid broad wildcard permissions unless genuinely required.
- Keep assignable scopes as narrow as practical.
- Test custom roles in a nonproduction environment before deployment.
- Separate role creation from role assignment where appropriate.
- Document the role's purpose, owner, and review schedule.

Official references:

- Create or update Azure custom roles using the Azure portal
- Azure CLI role definition commands

## 5. Azure RBAC roles vs. Microsoft Entra ID roles

Although both systems manage permissions, they protect different administrative surfaces.

| Characteristic | Azure RBAC roles | Microsoft Entra ID roles |
| --- | --- | --- |
| Primary purpose | Manage Azure resources | Manage identities and directory services |
| Examples | Owner, Contributor, Reader, custom resource roles | Global Administrator, User Administrator, Groups Administrator |
| Typical tasks | Manage virtual machines, storage accounts, networks, and resource groups | Create users, manage groups, reset passwords, and administer directory settings |
| Scope | Management group, subscription, resource group, or individual Azure resource | Tenant-wide, administrative unit, or supported individual directory objects |
| Role customization | Supports custom roles for Azure resource permissions | Supports custom directory roles for supported Microsoft Entra permissions |
| Assignment targets | Users, groups, service principals, and supported managed identities | Users, groups, and supported service principals for eligible roles and scenarios |
| Administration interface | Azure portal → Resource → Access control (IAM) | Microsoft Entra admin center → Entra ID → Roles and administrators |
| Typical use case | Allow an engineer to manage virtual machines in a specific resource group | Allow a helpdesk administrator to manage eligible users without granting Global Administrator privileges |

### Example scenarios

#### Scenario 1: Azure RBAC

An engineer needs permission to restart virtual machines in a particular resource group. Assign an appropriately scoped Azure RBAC role.

#### Scenario 2: Microsoft Entra ID role

A helpdesk administrator needs to reset passwords for eligible users. Assign an appropriate Microsoft Entra directory role.

#### Scenario 3: Both systems

An administrator may need to manage Azure resources and directory users. These permissions should be assigned independently according to the tasks required.

Key takeaway: Azure RBAC controls access to Azure resources, while Microsoft Entra ID roles control administrative access to identity and directory services. Having one role does not automatically grant the permissions of the other.

- **Official reference:** Azure roles, Microsoft Entra roles, and classic subscription administrator roles.

## 6. Quick revision checklist

- Know how to list subscriptions and identify the active subscription using PowerShell and Azure CLI.
- Understand the properties of an Azure custom role JSON file.
- Know how to create, validate, and assign a custom Azure RBAC role.
- Understand the difference between Azure resource permissions and directory administration permissions.
- Apply least privilege and scope role assignments appropriately.
- Review custom role permissions and assignments regularly.

## Conclusion

Azure subscription commands provide visibility into subscription configuration, tenants, resource groups, and role assignments. Azure custom RBAC roles allow organizations to define precise resource permissions when built-in roles are insufficient.

Microsoft Entra ID roles serve a different purpose by controlling directory administration. Understanding the distinction between these role systems helps administrators implement secure access controls, reduce unnecessary privileges, and manage Azure environments effectively.



------------------------------------------------------------------------


## Source 3: labs/2/researchQuestions2b.md

> Original file: `labs/2/researchQuestions2b.md`

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



------------------------------------------------------------------------


## Source 4: labs/3/researchQuestions.md

> Original file: `labs/3/researchQuestions.md`

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



------------------------------------------------------------------------


## Source 5: labs/3/WriteUp.MD

> Original file: `labs/3/WriteUp.MD`

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



------------------------------------------------------------------------


## Source 6: labs/4/WriteUp.MD

> Original file: `labs/4/WriteUp.MD`

# Lab 00 - Template
## Intro

## Scenario

## Tasks
- Task 1:
- Task 2:



------------------------------------------------------------------------


## Source 7: labs/5/WriteUp.MD

> Original file: `labs/5/WriteUp.MD`

# Lab 00 - Template
## Intro

## Scenario

## Tasks
- Task 1:
- Task 2:



------------------------------------------------------------------------


## Source 8: labs/7/WriteUp.MD

> Original file: `labs/7/WriteUp.MD`

# Lab 07 - Template
## Intro
In this lab you learn to create storage accounts for Azure blobs and Azure files. You learn to configure and secure blob containers. You also learn to use Storage Browser to configure and secure Azure file shares.
## Scenario
Your organization is currently storing data in on-premises data stores. Most of these files are not accessed frequently. You would like to minimize the cost of storage by placing infrequently accessed files in lower-priced storage tiers. You also plan to explore different protection mechanisms that Azure Storage offers, including network access, authentication, authorization, and replication. Finally, you want to determine to what extent Azure Files is suitable for hosting your on-premises file shares.
## Tasks
- Task 1: Create and configure a storage account.
- Task 2: Create and configure secure blob storage.
- Task 3: Create and configure secure Azure file storage.

## Write up
### Task 1: Create and configure a storage account
- Create a new storage account in the storage account service with the following parameters:

| Setting | Value |
| --- | --- |
|Subscription | the name of your Azure subscription|
|Resource group | az104-rg7 (create new)|
|Storage account name | az104lab07storageaccount|
|Region | (US) East US|
|Performance | Standard (notice the Premium option)|
|Preferred storage type | Azure Blob Storage or Azure Data Lake Storage|
|Redundancy | Geo-redundant storage (notice the other options)|
|Make read access to data available in the event of regional unavailability. | Check the box|

- Enable access from selected public networks --> Whitelised my public IP
- Created a lifecycle management rule:
    - Data Management Blade --> Lifecycle Management --> Add a rule
    - *If base blobs were last modified more than 30 days ago then Move to cool storage*

### Task 2: Create and configure secure blob storage
#### Create a blob container and a time-based retention policy
- Created a container in the storage account (Data Storage Blade --> Container --> Create)
- Created a time-based retention policy (180 days)
    - From the container list:
    - ... --> Access Policy --> Immutable blob storage --> Add Policy
    - Type: Time-based
    - Set 180 days
    - Save
#### Manage Blob uploads
- In the storage account's left menu, under Settings, select Configuration and set Allow storage account key access to Enabled, then click Save.
- From the Access Control (IAM) blade at the storage account level, added the following roles to my user:
    - Storage Blob Data Contributor
        - _Allows for read, write and delete access to Azure Storage blob containers and data_
    - Storage File Data Privileged Contributor 
        - _Customer has read, write, delete and modify NTFS permission access on Azure Storage file shares_
- Uploaded a test file to the container, from the storage browser blade
- Copied the file link and tried to access it from a private browser page --> Forbidden (OK)



------------------------------------------------------------------------


## Source 9: labs/Template/WriteUp.MD

> Original file: `labs/Template/WriteUp.MD`

# Lab 00 - Template
## Intro

## Scenario

## Tasks
- Task 1:
- Task 2:



------------------------------------------------------------------------


## Source 10: Notes/Compute/ComputeNotes.md

> Original file: `Notes/Compute/ComputeNotes.md`

# Learning Notes

## Introduction aux machines virtuelles

https://learn.microsoft.com/en-us/training/modules/intro-to-azure-virtual-machines

Une ressource Azure est un objet que l'on peut gérer dans Azure, par exemple une VM, un disque ou un réseau (VNet).

Une VM a besoin des éléments suivants :

- VM
- Disque
- Virtual Network
- IP
- Network Security Group (NSG)

Azure peut créer ces ressources lui-même ou utiliser des ressources existantes.
Les VM sont des ressources IaaS.

Les VM ont des paramètres comme le nom, la taille (CPU, RAM, GPU, etc.) et le système d'exploitation.
Il faut choisir la taille selon les besoins.

Les VM ont deux disques par défaut : un disque pour le système d'exploitation et un disque temporaire dont les données sont effacées lorsque la machine est arrêtée.
Il est possible d'ajouter d'autres disques persistants.

La VM possède une NIC (Network Interface Card) virtuelle avec une adresse IP privée et/ou publique dans un VNet.
Ainsi, la VM peut communiquer avec d'autres ressources Azure, avec Internet ou avec un contrôleur de domaine local (on-premises).

Toutes les ressources liées à une application ou à un projet sont regroupées dans un resource group.

### Liste de vérification pour la VM

#### Réseau

Les réseaux virtuels (VNet) constituent le réseau dans lequel la VM et les autres ressources communiquent.
Ils fonctionnent selon le même principe qu'un réseau traditionnel.
Par défaut, les ressources ne communiquent qu'avec les autres ressources du même réseau, mais il est possible de modifier ce comportement.

Lors de la création, il faut choisir une plage IP qui ne chevauche pas celle utilisée par un autre VNet ou par un réseau on-premises.
Il est ensuite possible de créer des sous-réseaux dans un VNet et de sécuriser le trafic à l'aide de Network Security Groups (NSG).
Dans chaque subnet, les premier 4 IPs et le dernier IP sont réservé pour la gestion du subnet.
Un NSG permet de définir des règles de communication entre sous-réseaux, ASG (Application Security Groups), adresses IP et ports. Il joue un rôle similaire à celui d'un pare-feu.

Par exemple :

1. **1 VNet**: Fa da perimetro di rete generale per la tua applicazione (es. `10.0.0.0/16`).
2. **Subnet dedicate**: Separi la rete in livelli logici (es. `FrontendSubnet` per il Web e `BackendSubnet` per il Database).
3. **ASG per Ruolo**: Assegni le schede di rete (NIC) delle VM ai relativi gruppi logici:

    - `ASG-Web` alle VM frontend.
    - `ASG-SQL` alle VM del database.

4. **NSG centralizzato a livello di Subnet**: Associ l'NSG alla Subnet e scrivi regole pulite basate sugli ASG:

    - **Regola 1 (Ingresso Web)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-Web` (Porta 443 HTTPS) ➔ **Allow**.
    - **Regola 2 (Web verso DB)**: Sorgente: `ASG-Web` ➔ Destinazione: `ASG-SQL` (Porta 1433 SQL) ➔ **Allow**.
    - **Regola 3 (Isolamento DB)**: Sorgente: `ServiceTag: Internet` ➔ Destinazione: `ASG-SQL` ➔ **Deny** (anche se la regola di default di Azure bloccherebbe già l'ingresso da Internet).

Ordre d'application des règles :
Les règles ont une priorité comprise entre 100 et 4096. La priorité la plus basse est appliquée en premier.
Azure vérifie toutes les règles une par une, en commençant par la valeur la plus petite, et s'arrête dès la première correspondance.

Si un NSG est associé à la fois à la NIC et au sous-réseau, les deux doivent autoriser le trafic. Si l'un d'eux le bloque, le trafic est refusé.
Trafic entrant : sous-réseau NSG --> NIC NSG
Trafic sortant : NIC NSG --> sous-réseau NSG

### VM

Une fois que le réseau a été planifié, il faut préparer la VM selon les besoins.

Il faut faire attention au nom de la VM, car il n'est pas simple de le modifier après sa création.
Ce nom devient également le nom d'hôte dans le système d'exploitation de la VM.
Il faut définir une convention de nommage cohérente :

- environnement (Dev, Prod, QA) ;
- emplacement (dans un environnement comportant plusieurs régions) ;
- instance (webapp01, webapp02, etc.) ;
- produit, service ou projet ;
- rôle.

Exemple Microsoft : deveus-webvm01

#### Location

Choisir l'emplacement le plus proche possible des utilisateurs.
Cela permet d'améliorer les performances et de respecter les réglementations locales.

Certaines fonctionnalités ne sont pas disponibles partout.
Il peut aussi y avoir des différences de prix.
S'il n'y a aucune restriction réglementaire ou liée aux performances, il peut être utile de comparer les prix.

#### Taille de la VM

Plutôt que de devoir tout configurer manuellement, Azure propose des tailles adaptées aux différents workloads.

- General Purpose
- Compute Optimized (CPU)
- Memory Optimized (RAM)
- Storage Optimized (Storage et I/O)
- GPU (workloads graphiques et d'intelligence artificielle)
- High Performance Compute (CPU renforcé et interface réseau à haut débit)

Il est possible de changer la taille d'une VM.
La modification redémarre la machine.

La taille détermine aussi le nombre de NIC utilisables pour une VM.

### Tarification

Les VM sont facturées, tout comme les composants qui y sont associés.
Composants facturés :

- VNet
- IP (privée et publique)
- Disques du système d'exploitation et disques supplémentaires
- Licence du système d'exploitation (si applicable)

Pour les VMs, le calcul et le stockage sont facturé séparément. Ce qui permet d'optimiser au mieux les coûts de ces ressources

La tarification du calcul est indiquée sur une base horaire, mais facturée à la minute.
Si une VM est utilisée 43 minutes, et désallouée ensuite, uniquement 43 minutes seront facturées.
Désallouer une VM libère le hardware sur laquelle elle tourne dans le DC Microsoft.
Le prix est basé sur la taille et l'OS. En cas de besoin d'une licence pour l'OS, le prix de celle-ci est incluse dans le prix de la VM.
Il est possible de récupérer et utiliser des licences on-premises existantes, pour les utiliser dans le cloud. Ce qui peut permettre de gagner quelques sous.

2 types de payements pour les VMs:

- Pay-as-you-go
  - Paye l'utilisation (à la seconde).
  - Pas de payements "upfront".
- Reserved Virtual Machine Instances
  - Reserver une VM pour une durée de 1 à plusieurs années.
  - Peut coûter 72% moins cher que le Pay as you go pour une utilisation équivalente.
  - Les coûts sont prévisibles et plus facilement budgétisables.

Le stockage n'est pas inclus dans le pricing des VMs.
Si une VM est éteinte, mais qu'un disque existe et contient des données, il faudra tout de même payer le storage.

### Stockage

Une VM a deux disques par défaut : le disque du système d'exploitation et un disque éphémère.
Il est conseillé de créer un disque distinct pour conserver les données persistantes.

#### Types de disques Azure

| | Ultra Disk | Premium SSD v2 | Premium SSD | Standard SSD | Standard HDD |
| --- | --- | --- | --- | --- | --- |
| **Type de disque** | SSD | SSD | SSD | SSD | HDD |
| **Scénario** | Charge de travail intensive en entrées/sorties, comme SAP HANA, les bases de données critiques (SQL, Oracle, etc.) et les autres charges de travail transactionnelles lourdes. | Charge de production et de performances sensibles à la latence, nécessitant une faible latence ainsi qu'un débit et un nombre d'IOPS élevés. | Charge de production et de performances sensibles à la latence. | Serveurs web peu utilisés, applications d'entreprise et environnements de développement/test. | Sauvegarde, accès occasionnel non critique et peu fréquent. |
| **Taille maximale du disque** | 65 536 GiB | 65 536 GiB | 32 767 GiB | 32 767 GiB | 32 767 GiB |
| **Débit maximal** | 4 000 Mo/s | 1 200 Mo/s | 900 Mo/s | 750 Mo/s | 500 Mo/s |
| **IOPS maximal** | 160 000 | 80 000 | 20 000 | 6 000 | 2 000 |
| **Peut être utilisé comme disque du système d'exploitation** | Non | Non | Oui | Oui | Oui |

### Système d'exploitation

Prix de la VM peut varier selon l'OS, car les licences et besoin matériels ne sont pas les mêmes par tout.

Pour certain services, il existes des image à installer qui ont déjà uns stack prêtes dans le marketplace.
Par exemple, pour un site web, on pourrait avoir une image avec apache, MySQL et PHP/NodeJS déjà installés.

Il est aussi possible de créer des images à installer selon nos besoins, et utiliser "Azure Compute Gallery" pour gérer des images custom.

Azure Compute Gallery est un service qui permet de gérer, versionner et distribuer des images OS entre plusieurs régions et abonnements Azure

### Création de VMs

Creation de ressources via:
- gui
- powershell/bash/cloudshell
- ARM Templates/Bicep/Terraform
- rest API
- Azure Client SDK

Il est possible de configurer un accès SSH lors de la création d'une VM

Quand on utilise des templates, il est possible non seulement de créer de nouvelles VMs, mais aussi de repousser le Json d'une VM existante pour en modifier la configuration

création d'une VM via azure CLI:

``` bash
az vm create --resource-group TestResourceGroup --name test-wp1-eus-vm --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys
```

création d'une VM via azure Powershell:

```Powershell
New-AzVm -ResourceGroupName "TestResourceGroup" -Name "test-wp1-eus-vm" -Location "East US" -Image Debian11 -VirtualNetworkName "test-wp1-eus-network" -SubnetName "default" -SecurityGroupName "test-wp1-eus-nsg" -PublicIpAddressName "test-wp1-eus-pubip" -GenerateSshKey -SshKeyName myPSKey -OpenPorts 22
```

"-OpenPorts" applique la configuration sur le NSG indiqué dans la commande.
le NSG ne fait pas de port forwarding. On expose donc la VM directement.
Pour faire du NAT et du Port forwarding, il faut utiliser: 
- Azure Bastion (best practice pour la gestion des accès admin)
- Azure Load Balancer
- Azure Firewall

Le client SDK est disponible pour C#, Java, Node.js, PHP, Python, Ruby, and go
les languages basés sur .net

les Azure VM Extentions sont des outils qui permettent de configurer et automatiser des tâches sur les VMs après le déploiement de celles-ci

Azure Automation services permet d'automatiser des tâches dans Azure:
- Script qui automatise une tâche repetitive
- Surveiller se des MAJ d'applications qui tournent sur in VM est disponible
- Surveiller les MAJ OS des VMs


Auto-shutdown
--> Plannifier des crainaux horaires lors des quel eteindre les VM dont on aurait pas besoin
permet d'économiser sur la facture.



------------------------------------------------------------------------


## Source 11: plan.md

> Original file: `plan.md`

# AZ-104 — Revised Study Plan

## Context

- Current date: **19 November 2026**
- Goal: be ready to attempt **AZ-104 by the end of November 2026**, if readiness is sufficient.
- Exam is **not booked yet**.
- If the next practice assessment shows that readiness is still too low, postpone the exam instead of forcing an attempt.
- Initial baseline practice assessment: **52% overall**.
- Approximate initial strengths/weaknesses:
  - Storage: ~75%
  - Identity & Governance: ~65–70%
  - Networking: ~55%
  - Compute: ~30–35%
  - Monitor / Maintain: ~25%
- Current progress:
  - Compute study has started.
  - Completed the introductory Azure VM checklist unit.
  - Notes have been too detailed and are slowing down progress.
- New strategy:
  - prioritize **coverage + active recall + targeted labs**
  - reduce note-taking
  - use labs only where hands-on work adds real value
  - use practice results to decide whether to book the exam

---

# Main Priorities

Study priority based on exam weight + current weaknesses:

1. **Compute**
2. **Monitor / Backup / Recovery**
3. **Networking**
4. **Identity & Governance**
5. **Storage**

Do not study all domains equally.

The goal is to turn strong areas into reliable points and rapidly raise weak areas to a safe level.

---

# Study Method

For each study block:

1. **Official Microsoft Learn / documentation**
2. **Minimal notes**
3. **Scenario questions / active recall**
4. **Hands-on only if useful**
5. **Log mistakes**

Target structure for a normal session:

- 50–70 min learning
- 15–25 min concise notes
- 25–40 min questions / recall
- 10 min gap log
- optional 20–40 min lab when worthwhile

## Note-taking rule

Do **not** rewrite Microsoft Learn.

Only note:

- Azure-specific behavior
- differences between similar services
- exam traps
- values/rules worth remembering
- things I got wrong
- things I did not already know

Example:

Do not write:

> A subnet is a subdivision of a network.

Write:

> Azure reserves the first 4 IPs and the last IP of every subnet.

Target compression:

> ~10 pages of Microsoft Learn → 1–2 pages of useful notes

---

# Readiness Criteria

The next practice assessment is the main decision point.

## Green light

Book / sit the exam if:

- overall score is **80%+**
- no major domain is below **70%**
- I can explain why wrong answers are wrong
- results are not just memorized from previous questions

## Borderline

If overall score is **75–79%**:

- review the type of mistakes
- if mainly details / wording → exam may still be reasonable
- if major conceptual gaps remain → postpone

## Not ready

If overall score is:

- **65–74%** → postpone a few days and remediate
- **below 65%** → postpone and rebuild the plan around weak domains

---

# Revised Calendar Plan

## Friday 20 November — Compute I: VM Core

**Duration:** 2h

### Topics

- VM architecture
- VM sizes
- images
- OS disk
- data disks
- temporary disk
- managed disks
- resizing
- deallocation
- Azure Compute Gallery

### Study goal

Be able to explain:

- what resources a VM depends on
- OS disk vs data disk vs temporary disk
- what happens when a VM is stopped vs deallocated
- how VM size affects compute and NIC limits
- why managed disks exist

### Lab

No subscription required yet.

Read simple VM creation workflows, Bicep/ARM examples and PowerShell commands.

### Done when

- VM fundamentals can be explained without notes
- at least 15 Compute questions completed
- unclear topics added to `AZ104-GAPS.md`

---

## Saturday 21 November — Compute II: Availability and Scale

**Duration:** 2h30

### Topics

- Availability Sets
- Fault Domains
- Update Domains
- Availability Zones
- VM Scale Sets
- autoscaling
- scale up vs scale out

### Key comparison

Be able to choose between:

- single VM
- Availability Set
- Availability Zone
- VM Scale Set

### Optional lab

If no subscription:

- study diagrams and deployment workflows only

If subscription exists:

- create a small VMSS
- inspect instances
- inspect scaling settings
- delete resources afterward

### Done when

- availability choices can be selected from scenarios
- at least 20 scenario questions completed
- weak concepts logged

---

## Sunday 22 November — Compute III: App Service, Containers and IaC

**Duration:** 2h30

### Topics

#### App Service

- App Service Plan
- scaling
- deployment slots
- custom domains
- TLS
- backups
- networking basics

#### Containers

- Azure Container Registry
- Azure Container Instances
- Azure Container Apps

#### IaC

- ARM templates
- Bicep
- parameters
- variables
- resources
- outputs
- deployment scope

### Goal

Do not learn Bicep deeply.

Be able to:

- read a basic Bicep template
- recognize what is being deployed
- understand parameterization
- choose ACI vs Container Apps vs App Service in simple scenarios

### Done when

- 20+ Compute questions completed
- target **70%+ on Compute mini-test**

---

## Monday 23 November — Monitor, Logs and Alerts

**Duration:** 2h15

### Topics

- Azure Monitor
- metrics vs logs
- Log Analytics Workspace
- diagnostic settings
- alerts
- action groups
- Insights
- basic KQL recognition
- Activity Log

### Mental model

Resource  
→ metric / log  
→ Azure Monitor  
→ alert rule  
→ action group  
→ notification / automation

### Done when

- difference between metrics, logs and Activity Log is clear
- can explain alert + action group workflow
- can read a basic KQL query
- 15–20 questions completed

---

## Tuesday 24 November — Backup, Recovery and Network Monitoring

**Duration:** 2h15

### Topics

- Azure Backup
- Backup Vault
- Recovery Services Vault
- backup policies
- restore
- Site Recovery
- failover
- Network Watcher
- Connection Monitor

### Key comparison

Be able to explain:

- Backup vs Site Recovery
- Recovery Services Vault vs Backup Vault at a high level
- backup vs business continuity / disaster recovery

### Done when

- restore and failover workflows are understood
- 15–20 questions completed
- Monitor/Backup mini-test target: **70%+**

---

## Wednesday 25 November — Networking I

**Duration:** 2h15

### Topics

- VNets
- subnets
- IP addressing
- NSG
- ASG
- effective security rules
- UDR
- VNet peering
- Bastion
- public IP

### Existing knowledge

Do not spend time relearning:

- subnet basics
- routing basics
- firewall basics
- CIDR fundamentals

Focus on **Azure-specific implementation**.

### Done when

- can trace traffic through subnet/NIC NSGs
- can reason about effective rules
- can explain UDR and peering
- 20 networking questions completed

---

## Thursday 26 November — Networking II + Storage Refresh

**Duration:** 2h30

### Networking

- Private Endpoint
- Service Endpoint
- Private DNS
- Azure DNS
- internal vs public Load Balancer
- health probes
- backend pools
- troubleshooting connectivity

### Storage refresh

Only revise:

- redundancy
- SAS
- keys vs identity
- Blob tiers
- lifecycle management
- Azure Files
- Storage firewall
- AzCopy / Storage Explorer

### Key comparison

Know clearly:

- Private Endpoint vs Service Endpoint
- LRS / ZRS / GRS / GZRS
- SAS vs access keys vs RBAC

### Done when

- Networking quiz: target **75%+**
- Storage quiz: target **80%+**

---

## Friday 27 November — Identity and Governance Refresh

**Duration:** 2h

### Focus only on Azure-specific areas

- Azure RBAC
- scopes
- inheritance
- custom roles
- Management Groups
- subscriptions
- Resource Groups
- Azure Policy
- resource locks
- tags
- budgets
- Advisor

### Do not over-study familiar IAM topics

Entra users/groups are already relatively strong.

### Key comparisons

- Azure RBAC vs Entra roles
- RBAC vs Azure Policy
- Policy vs resource locks
- subscription vs management group vs resource group scope

### Done when

- 20 governance questions completed
- target **80%+**

---

## Saturday 28 November — Full Practice Assessment

**Duration:** 2h30–3h

### Rules

- fresh attempt
- closed notes
- no web search
- treat it like the exam

### After assessment

Record:

- overall score
- domain scores
- every wrong answer
- every guessed answer
- every topic that felt uncertain

Update:

`AZ104-GAPS.md`

### Decision

#### If ≥80%

Book the exam for the earliest reasonable slot near the end of November / beginning of December.

#### If 75–79%

Do targeted remediation Sunday and decide afterward.

#### If <75%

Do not rush the exam.

Postpone and rebuild the next study phase from the weak domains.

---

## Sunday 29 November — Targeted Remediation

**Duration:** 2–3h

Study **only** the top weaknesses from the 28 November assessment.

Do not restart entire Microsoft Learn paths.

For each weak topic:

1. read official documentation
2. write 3–5 concise bullets
3. complete targeted questions
4. explain the concept aloud / from memory

### Done when

- top 3 weaknesses have been reviewed
- fresh questions on those topics reach ~80%

---

## Monday 30 November — Readiness Check / Optional Exam Window

**Duration:** depends on outcome

### If ready

- light review only
- no new major topics
- sit AZ-104 if a suitable exam slot is available

### If not ready

- do not force an exam just to meet the November target
- move the exam to early December
- continue targeted remediation

---

# Azure Subscription Strategy

Do not create an Azure subscription just to complete very basic introductory labs.

Create/use a subscription when hands-on work becomes valuable for:

- VM Scale Sets
- disks
- NSGs
- VNet peering
- Private Endpoints
- Service Endpoints
- Azure Monitor
- Log Analytics
- Azure Backup
- App Service
- Policy / RBAC / Locks

Use a dedicated lab resource group.

Example:

```text
RG-AZ104-LAB
```

After each lab:

- delete unnecessary resources
- check remaining disks
- check public IPs
- check vault items
- verify nothing billable was accidentally left behind

---

# NotebookLM Strategy

Use NotebookLM as a study assistant, not as the source of truth.

Source of truth:

1. official AZ-104 study guide
2. Microsoft Learn
3. official Microsoft documentation
4. existing Geneva training notes and labs

Use NotebookLM for:

- scenario questions
- flashcards
- comparisons
- active recall
- weak-topic drills

Prefer questions like:

> A company has VNet A, VNet B and a storage account with requirement X. Which Azure configuration satisfies the requirement with the least administrative effort?

Avoid spending too much time on definition-only questions.

---

# Gap Log

Maintain:

```text
AZ104-GAPS.md
```

Format:

```md
## Compute

✅ Managed disks
⚠️ Availability Set vs Zone
❌ VMSS autoscale rules

## Networking

✅ NSG
⚠️ Load Balancer probes
❌ Private Endpoint + Private DNS

## Monitor

❌ Diagnostic settings
⚠️ Metrics vs Logs
```

Legend:

- ✅ confident
- ⚠️ partially understood
- ❌ weak / wrong in practice

Use the gap log to decide the next review session.

---

# Instructions for Gemini Calendar Scheduling

Use this plan to update my calendar.

## Scheduling rules

1. Time zone: **Europe/Zurich**.
2. Schedule sessions from **20 November through 30 November 2026**.
3. Preserve the topic order unless calendar conflicts make that impossible.
4. Prefer:
   - train time for reading, notes, flashcards and questions
   - desk/internet time for labs
5. Sessions may be split into 45–75 minute blocks if necessary.
6. Preserve the total planned study duration for each day.
7. Do not schedule labs during train travel unless no Azure interaction is required.
8. Add a **15-minute reminder** to study sessions.
9. Keep **28 November** reserved for the full practice assessment.
10. Keep **29 November** for remediation based on that result.
11. Treat **30 November** as a readiness/exam window, not as a mandatory exam date.
12. Do not create an exam booking automatically.
13. If there is insufficient free time, prioritize:
    - Compute
    - Monitor / Backup
    - Networking
14. Do not silently delete missed topics. Flag them for replanning.
15. If a session has already elapsed when this file is imported, reschedule it into the next available slot without moving the practice assessment unless necessary.

---

# Target Outcome

By the next full practice assessment:

- Compute: **≥75%**
- Monitor / Backup: **≥70%**
- Networking: **≥75%**
- Identity / Governance: **≥80%**
- Storage: **≥80%**
- Overall: **≥80% preferred**

The goal is not to finish every Microsoft Learn page.

The goal is to be able to correctly reason through AZ-104 scenarios across all exam domains.
