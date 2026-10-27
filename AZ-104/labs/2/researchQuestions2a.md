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