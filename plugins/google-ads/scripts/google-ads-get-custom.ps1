#Requires -Version 7.0
# google-ads-get-custom.ps1 - Fetch custom GAQL query data
param(
    [string]$ProjectRoot = ".",
    [Parameter(Mandatory=$true)][string]$Name,
    [Parameter(Mandatory=$true)][string]$Query
)

$config = Get-Content "$ProjectRoot\config.json" | ConvertFrom-Json
$zipFile = "$ProjectRoot\response.zip"
$customDir = "$ProjectRoot\data\custom"

Write-Host "Running custom query '$Name'..."

$body = @{
    loginCustomerId = $config.loginCustomerId
    clientCustomerId = $config.clientCustomerId
    gptToken = $config.gptToken
    name = $Name
    query = $Query
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "https://api.gaql.app/api/cli/google-ads/get-ai-custom-data" -Method POST -Body $body -ContentType "application/json" -OutFile $zipFile -ErrorAction Stop | Out-Null
} catch {
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Error: $errorBody"
    } else {
        Write-Host "Error: $($_.Exception.Message)"
    }
    exit 1
}

if (-not (Test-Path $customDir)) { New-Item -ItemType Directory -Path $customDir -Force | Out-Null }

Expand-Archive -Path $zipFile -DestinationPath $customDir -Force
Remove-Item $zipFile

$resultFile = "$customDir\$Name.md"
if (Test-Path $resultFile) {
    Write-Host ""
    Write-Host "=== Query Results ==="
    Get-Content $resultFile
    Write-Host ""
    Write-Host "Results saved to $resultFile"
} else {
    Write-Host "Results extracted to $customDir"
}
