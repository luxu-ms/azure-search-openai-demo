if($args.Length -lt 7){
    Write-Host "The required parameters should be provided."
    Write-Host "deploy.ps1 <environment name> <project name> <dev center name> <environment type> <catalog name> <catalog item name> <principal id>"
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
$devcenterName = $args[2]
$environmentType = $args[3]
$catalogName = $args[4]
$catalogItemName = $args[5]
$principalId = $args[6]

Write-Host "Provisioning Azure resources..."
$result = az devcenter dev environment create --dev-center-name $devcenterName `
                                    --project-name $projectName `
                                    --environment-name $environmentName `
                                    --environment-type $environmentType `
                                    --catalog-name $catalogName `
                                    --catalog-item-name $catalogItemName `
                                    --parameters "{'environmentName':'$environmentName','principalId':'$principalId','backendServiceName':'$backendServiceName','storageAccountName':'$storageAccountName', 'searchServiceName':'$searchServiceName', 'formRecognizerServiceName':'$formRecognizerServiceName'}" 

Write-host "Deploying App service..."
Set-Location 'app'
.\start.ps1

Set-Location '../'
Compress-Archive -Path backend\* -DestinationPath backend.zip -Force
Start-Sleep -Seconds 60
az webapp deploy --resource-group $resourceGroup --name $backendServiceName --src-path backend.zip

Write-Host "Uploading gpt docs..."
Set-Location "../"
.\scripts\prepdocs.ps1 $storageAccountName $searchServiceName $formRecognizerServiceName

Write-Host "Completed!"