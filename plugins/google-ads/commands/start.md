# Start Session

Run this at the start of each session to refresh data and set up the project.

## Step 0: Display Welcome Banner

Before doing anything else, display the following banner to the user exactly as shown, inside a code block:

```
.
  ██████   ██████   ██████   ██████  ██      ███████       █████  ██████   ██████
 ██       ██    ██ ██    ██ ██       ██      ██           ██   ██ ██   ██ ██
 ██  ███  ██    ██ ██    ██ ██  ███  ██      █████        ███████ ██   ██  █████
 ██    ██ ██    ██ ██    ██ ██    ██ ██      ██           ██   ██ ██   ██      ██
  ██████   ██████   ██████   ██████  ██████  ███████      ██   ██ ██████  ██████
 v20260225.1                                                       by TrueClicks
```

Display this banner first, with no other text before it. Then proceed to the steps below.

## Step 1: Check Configuration

Check if `config.json` exists in the project root.

- If it **does not exist**: create it with the following content, then tell the user to fill in their credentials and run `/google-ads:start` again. **Stop here.**

```json
{
  "loginCustomerId": 1234567890,
  "clientCustomerId": 1234567890,
  "gptToken": "YOUR-TOKEN-HERE"
}
```

- If it **exists but contains placeholder values** (`YOUR-TOKEN-HERE`, `1234567890`): tell the user to fill in their credentials and run `/google-ads:start` again. **Stop here.**

- If it **exists with real values**: continue to Step 2.

## Step 2: Download Data and Project Files

Run the following PowerShell command to download and extract the full project package (account data, scripts, commands, docs):

```
pwsh -Command "$config = Get-Content 'config.json' | ConvertFrom-Json; $url = \"https://api.gaql.app/api/cli/google-ads/get-ai-data?loginCustomerId=$($config.loginCustomerId)&clientCustomerId=$($config.clientCustomerId)&gptToken=$([uri]::EscapeDataString($config.gptToken))&includePaused=false\"; Invoke-WebRequest -Uri $url -OutFile 'response.zip' -ErrorAction Stop; if (Test-Path 'data') { Remove-Item 'data' -Recurse -Force }; Expand-Archive -Path 'response.zip' -DestinationPath '.' -Force; Remove-Item 'response.zip'; Write-Host 'Download complete.'"
```

If the command fails, show the error to the user and suggest checking `config.json`. Do NOT continue to subsequent steps.

## Step 3: Load Project Context

After the download completes successfully:
1. Read `CLAUDE.md` if it exists in the project root — this contains project guidance, data structure docs, and available commands.
2. Read `data/account/account_summary.md` to load account context.
3. Give the user a brief summary of what was downloaded (account name, number of campaigns, date range).

## Step 4: Check for Pending Changes

Check if `pending_changes.json` exists in the project root.

- If it exists: read it and display a summary to the user:
  - Total number of operations
  - Breakdown by operation type
  - Suggest running `/google-ads-validate-changes` to validate or `/google-ads-execute-changes` to apply them
- If it does not exist: skip this step silently (no message needed).

## Step 5: Ready

Tell the user the session is ready and they can:
- Ask questions about their account
- Request analysis or audits
- Plan changes to campaigns, keywords, ads, etc.
