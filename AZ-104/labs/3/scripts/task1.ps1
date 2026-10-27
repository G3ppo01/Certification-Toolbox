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

# Export disk as an ARM template
$armPath = "$psScriptRoot\..\az104-disk1-script-template.json"

$disk = Get-AzDisk -ResourceGroupName $resourceGroup -DiskName $diskName

Export-AzResourceGroup `
    -ResourceGroupName $resourceGroup `
    -Resource $disk.Id `
    -Path $armPath `
    -Force

<#export the disk as a Bicep template --NOT WORKING YET, EXPORTS EMPTY FILES
$bicepPath = "$psScriptRoot\..\az104-disk1-script-template.bicep"

Export-AzResourceGroup `
    -ResourceGroupName $resourceGroup `
    -Resource $disk.Id `
    -OutputFormat Bicep `
    -Path $bicepPath `
    -Force
#>

#Convert the ARM template to a Bicep template

if (-not (Get-Command "bicep" -ErrorAction SilentlyContinue)) {
    Write-Host "Bicep CLI is not installed. Please install it from https://aka.ms/bicep/install"
    exit
}

bicep decompile "$armPath" --outfile "$psScriptRoot\..\az104-disk1-script-template.bicep"