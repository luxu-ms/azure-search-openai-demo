if($args.Length -lt 8){
    Write-Host "The required parameters should be provided."
    Write-Host "deploy.ps1 <environment name> <project name> <tenant id> <dev center name> <environment type> <catalog name> <catalog item name> <principal id>"
    exit
}

$environmentName = $args[0]
$projectName = $args[1]

function Get-UniqueString ([string]$id, $length=13)
{
    $hashArray = (new-object System.Security.Cryptography.SHA512Managed).ComputeHash($id.ToCharArray())
    -join ($hashArray[1..$length] | ForEach-Object { [char]($_ % 26 + [byte][char]'a') })
}

$resourceGroup = "$projectName-$environmentName"
$resourceToken = Get-UniqueString($resourceGroup)

$backendServiceName = "app-backend-$resourceToken"
$storageAccountName = "st$resourceToken"
$searchServiceName = "gptkb-$resourceToken"
$formRecognizerServiceName = "cog-fr-$resourceToken"
$tenantId = $args[2]
$devcenterName = $args[3]
$environmentType = $args[4]
$catalogName = $args[5]
$catalogItemName = $args[6]
$principalId = $args[7]

Write-Host "Provisioning Azure resources..."
$result = az devcenter dev environment create --dev-center-name $devcenterName `
                                    --project-name $projectName `
                                    --environment-name $environmentName `
                                    --environment-type $environmentType `
                                    --catalog-name $catalogName `
                                    --catalog-item-name $catalogItemName `
                                    --parameters "{'environmentName':'$environmentName','principalId':'$principalId','backendServiceName':'$backendServiceName','storageAccountName':'$storageAccountName', 'searchServiceName':'$searchServiceName', 'formRecognizerServiceName':'$formRecognizerServiceName'}" 

$result

Write-host "Deploying App service..."
Set-Location 'app'
.\start.ps1

Set-Location '../'
Compress-Archive -Path backend\* -DestinationPath backend.zip -Force
az webapp deploy --resource-group $resourceGroup --name $backendServiceName --src-path backend.zip

Write-Host "Uploading gpt docs..."
Set-Location "../"
.\scripts\prepdocs.ps1 $storageAccountName $searchServiceName $formRecognizerServiceName $tenantId

Write-Host "Completed!"