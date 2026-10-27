Connect-AzAccount
$subscription = Get-AzSubscription | Out-GridView -Title "Select a subscription" -PassThru
Set-AzContext -SubscriptionId $subscription.Id

$template_task3 = "$psScriptRoot\..\task3\template_task3.json"
$parameters_task3 = "$psScriptRoot\..\task3\parameters_task3.json"

New-AzResourceGroupDeployment -ResourceGroupName az104-rg3 -TemplateFile $template_task3 -TemplateParameterFile $parameters_task3

#Check if the disk was created successfully
Get-AzDisk -ResourceGroupName az104-rg3 -DiskName az104-disk3