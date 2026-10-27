Connect-AzAccount
$subscription = Get-AzSubscription | Out-GridView -Title "Select a subscription" -PassThru
Set-AzContext -SubscriptionId $subscription.Id

$resourceGroup = "az104-rg3"
$location = "eastus"
$diskName = "az104-disk1-script"

if (-not (Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroup -Location $location
}

# Create an empty 32-GiB Standard HDD managed disk
$diskConfig = New-AzDiskConfig `
    -Location $location `
    -CreateOption Empty `
    -DiskSizeGB 32 `
    -SkuName Standard_LRS

New-AzDisk `
    -ResourceGroupName $resourceGroup `
    -DiskName $diskName `
    -Disk $diskConfig