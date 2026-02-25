#Requires -Version 7.0
# google-ads-execute-changes.ps1 - Execute pending changes in Google Ads
param([string]$ProjectRoot = ".")

$config = Get-Content "$ProjectRoot\config.json" | ConvertFrom-Json
$pendingFile = "$ProjectRoot\pending_changes.json"
$historyDir = "$ProjectRoot\change-history"

if (-not (Test-Path $pendingFile)) {
    Write-Host "Error: pending_changes.json not found"
    exit 1
}

$pending = Get-Content $pendingFile -Raw | ConvertFrom-Json
Write-Host "Executing $($pending.operations.Count) operations..."

$body = @{
    pendingChanges = @{
        loginCustomerId = $config.loginCustomerId
        clientCustomerId = $config.clientCustomerId
        operations = @($pending.operations)
    }
    gptToken = $config.gptToken
} | ConvertTo-Json -Depth 20

try {
    $result = Invoke-RestMethod -Uri "https://api.gaql.app/api/cli/google-ads/execute-changes" -Method POST -Body $body -ContentType "application/json" -ErrorAction Stop

    Write-Host ""
    Write-Host "=== Execution Results ==="
    $result | ConvertTo-Json -Depth 10

    # Archive to change-history
    if (-not (Test-Path $historyDir)) { New-Item -ItemType Directory -Path $historyDir -Force | Out-Null }

    $timestamp = Get-Date -Format "yyyyMMdd-HHmm"
    $isoTimestamp = Get-Date -Format "o"
    $historyFile = "$historyDir\changes-$timestamp.json"

    $pending | Add-Member -NotePropertyName "status" -NotePropertyValue "executed" -Force
    $pending | Add-Member -NotePropertyName "executed_at" -NotePropertyValue $isoTimestamp -Force
    $pending | Add-Member -NotePropertyName "execution_results" -NotePropertyValue $result -Force

    $pending | ConvertTo-Json -Depth 20 | Set-Content $historyFile
    Write-Host ""
    Write-Host "Change history saved to: $historyFile"

    # Remove pending_changes.json after successful archive
    Remove-Item $pendingFile -Force
    Write-Host "Removed pending_changes.json"

    # Summary
    Write-Host ""
    if ($result.success -eq $true -and $result.failedOperations -eq 0) {
        Write-Host "SUCCESS: All $($result.successfulOperations) operations executed successfully."
    } else {
        Write-Host "PARTIAL: $($result.successfulOperations) succeeded, $($result.failedOperations) failed."
    }
    Write-Host ""
    Write-Host "Recommend running /google-ads:get to refresh local data."

} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.ErrorDetails) {
        Write-Host $_.ErrorDetails.Message
    }
    exit 1
}
