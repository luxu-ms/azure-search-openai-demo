$resourceGroup = Read-Host "Please enter name of resource group"
$appServicePlanName = Read-Host "Please enter name of app service plan e.g. plan-xxx"
$backendServiceName = Read-Host "Please enter name of app service e.g. app-backend-xxx"
$storageAccountName = Read-Host "Please enter name of storge account e.g. stxxx"
$searchServiceName = Read-Host "Please enter name of search service e.g. gptkb-xxx"
$formRecognizerServiceName = Read-Host "Please enter name of form recognizer .e.g. cog-fr-xxx"
$location=Read-Host "Please enter location e.g. eastus"

Write-host "Deploying App service..."
Set-Location 'app'
.\start.ps1

Set-Location '../backend' 
az webapp up -n $backendServiceName -g $resourceGroup -p $appServicePlanName -l $location

Write-Host "Uploading gpt docs..."
Set-Location "../../"
.\scripts\prepdocs.ps1 $storageAccountName $searchServiceName $formRecognizerServiceName

Write-Host "Completed!"