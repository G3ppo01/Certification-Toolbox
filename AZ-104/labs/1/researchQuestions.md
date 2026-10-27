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