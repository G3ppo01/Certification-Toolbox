# Sign in and select the target subscription.
Connect-AzAccount
$subscription = Get-AzSubscription | Out-GridView -Title "Select a subscription" -PassThru
Set-AzContext -SubscriptionId $subscription.Id

# Target resources and allowed public IP.
$resourceGroup = "az104-lab6-rg"
$accountName = "az104lab6storageaccount"
$allowedIP = "212.25.21.70"

# Create a GRS general-purpose v2 storage account.
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $accountName -Location "switzerlandnorth" -SkuName Standard_GRS -Kind StorageV2 -PublicNetworkAccess Enabled

# Deny network access by default; allow the specified IP.
Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $resourceGroup -Name $accountName -DefaultAction Deny -IpRule (@{IPAddressOrRange=$allowedIP;Action="allow"})

# Move base blobs to Cool after 30 days without modification.
$action = Add-AzStorageAccountManagementPolicyAction -BaseBlobAction TierToCool -daysAfterModificationGreaterThan 30

# Apply to block blobs throughout this account (no prefix restriction).
$filter = New-AzStorageAccountManagementPolicyFilter -BlobType blockBlob

# Create and apply the lifecycle rule to this account.
$rule = New-AzStorageAccountManagementPolicyRule -Name "MoveToCool" -Action $action -Filter $filter
Set-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroup -StorageAccountName $accountName -Rule $rule