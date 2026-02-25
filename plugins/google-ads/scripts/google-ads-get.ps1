#Requires -Version 7.0
# google-ads-get.ps1 - Download and extract Google Ads data
#
# Parameters:
#   -ProjectRoot    Path to project root (default: current directory)
#   -IncludePaused  Include paused campaigns, ad groups, ads, and keywords (default: active only)
#
# Usage:
#   .\google-ads-get.ps1                    # Active entities only
#   .\google-ads-get.ps1 -IncludePaused     # Include paused entities

param(
    [string]$ProjectRoot = ".",
    [switch]$IncludePaused
)

$config = Get-Content "$ProjectRoot\config.json" | ConvertFrom-Json
$zipFile = "$ProjectRoot\response.zip"
$dataDir = "$ProjectRoot\data"

Write-Host "Fetching data for client $($config.clientCustomerId)..."

$includePausedParam = $IncludePaused.ToString().ToLower()
$url = "https://api.gaql.app/api/cli/google-ads/get-ai-data?loginCustomerId=$($config.loginCustomerId)&clientCustomerId=$($config.clientCustomerId)&gptToken=$([uri]::EscapeDataString($config.gptToken))&includePaused=$includePausedParam"

try {
    Invoke-WebRequest -Uri $url -OutFile $zipFile -ErrorAction Stop | Out-Null
} catch {
    Write-Host "Error: Failed to fetch data."
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Message: $($_.Exception.Message)"
    exit 1
}

if (Test-Path $dataDir) { Remove-Item $dataDir -Recurse -Force }

Expand-Archive -Path $zipFile -DestinationPath $ProjectRoot -Force
Remove-Item $zipFile

$accountSummary = "$dataDir\account\account_summary.md"
if (Test-Path $accountSummary) {
    Write-Host ""
    Write-Host "=== Account Summary ==="
    Get-Content $accountSummary
    Write-Host ""
}

Write-Host "Data extracted to $dataDir"
