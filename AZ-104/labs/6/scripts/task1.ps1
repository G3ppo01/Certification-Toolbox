Connect-AzAccount
$subscription = Get-AzSubscription | Out-GridView -Title "Select a subscription" -PassThru
Set-AzContext -SubscriptionId $subscription.Id

$resourceGroup = "az104-day3-rg"
$accountName = "az104day3storageaccount"
$allowedIP = "212.25.21.70"
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $accountName -Location "switzerlandnorth" -SkuName Standard_GRS -Kind StorageV2 -PublicNetworkAccess Enabled
Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $resourceGroup -Name $accountName -DefaultAction Deny -IpRule (@{IPAddressOrRange=$allowedIP;Action="allow"})

$action = Add-AzStorageAccountManagementPolicyAction -BaseBlobAction TierToCool -daysAfterModificationGreaterThan 30
$filter = New-AzStorageAccountManagementPolicyFilter -BlobTypes block -PrefixMatch @("container1/","container2/")
$rule = New-AzStorageAccountManagementPolicyRule -Name "MoveToCool" -Enabled $true -Actions $action -Filters $filter