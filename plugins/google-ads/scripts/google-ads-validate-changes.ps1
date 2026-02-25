#Requires -Version 7.0
# google-ads-validate-changes.ps1 - Validate pending changes against Google Ads API
param([string]$ProjectRoot = ".")

$config = Get-Content "$ProjectRoot\config.json" | ConvertFrom-Json
$pendingFile = "$ProjectRoot\pending_changes.json"

if (-not (Test-Path $pendingFile)) {
    Write-Host "Error: pending_changes.json not found"
    exit 1
}

$pending = Get-Content $pendingFile | ConvertFrom-Json
Write-Host "Validating $($pending.operations.Count) operations..."

$body = @{
    pendingChanges = @{
        loginCustomerId = $config.loginCustomerId
        clientCustomerId = $config.clientCustomerId
        operations = $pending.operations
    }
    gptToken = $config.gptToken
} | ConvertTo-Json -Depth 20

try {
    $result = Invoke-RestMethod -Uri "https://api.gaql.app/api/cli/google-ads/validate-changes" -Method POST -Body $body -ContentType "application/json" -ErrorAction Stop
    $result | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
    exit 1
}
