if($args.Length -lt 4){
  Write-Host "The required parameters should be provided."
  Write-Host "prepdocs.ps1 <storage account> <search service> <form recognizer service> <tenant id>"
  exit
}

$AZURE_STORAGE_ACCOUNT = $args[0]
$AZURE_SEARCH_SERVICE = $args[1]
$AZURE_FORMRECOGNIZER_SERVICE = $args[2]
$AZURE_TENANT_ID = $args[3]

$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
  # fallback to python3 if python not found
  $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}

Write-Host 'Creating python virtual environment "scripts/.venv"'
Start-Process -FilePath ($pythonCmd).Source -ArgumentList "-m venv ./scripts/.venv" -Wait -NoNewWindow

$venvPythonPath = "./scripts/.venv/scripts/python.exe"
if (Test-Path -Path "/usr") {
  # fallback to Linux venv path
  $venvPythonPath = "./scripts/.venv/bin/python"
}

Write-Host 'Installing dependencies from "requirements.txt" into virtual environment'
Start-Process -FilePath $venvPythonPath -ArgumentList "-m pip install -r ./scripts/requirements.txt" -Wait -NoNewWindow

Write-Host 'Running "prepdocs.py"'
$cwd = (Get-Location)
Start-Process -FilePath $venvPythonPath -ArgumentList "./scripts/prepdocs.py $cwd/data/* --storageaccount $AZURE_STORAGE_ACCOUNT --container content --searchservice $AZURE_SEARCH_SERVICE --index gptkbindex --formrecognizerservice $AZURE_FORMRECOGNIZER_SERVICE --tenantid $AZURE_TENANT_ID -v" -Wait -NoNewWindow
