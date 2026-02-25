# Start Session

Run this at the start of each session to refresh data and check pending work.

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

## Step 1: Refresh Account Data

Run the data fetch script:

```
pwsh -ExecutionPolicy Bypass -File scripts/google-ads-get.ps1
```

The script reads `config.json`, calls the API, downloads the zip, extracts it to `data/`, and prints the account summary.

After the script completes successfully:
1. Read `data/account/account_summary.md` to load account context.
2. Give the user a brief summary of what was downloaded (account name, number of campaigns, date range).

If the script fails, show the error message to the user and suggest checking `config.json`. Do NOT continue to subsequent steps.

## Step 2: Check for Pending Changes

Check if `pending_changes.json` exists in the project root.

- If it exists: read it and display a summary to the user:
  - Total number of operations
  - Breakdown by operation type
  - Suggest running `/google-ads:validate-changes` to validate or `/google-ads:execute-changes` to apply them
- If it does not exist: skip this step silently (no message needed).

## Step 3: Ready

Tell the user the session is ready and they can:
- Ask questions about their account
- Request analysis or audits
- Plan changes to campaigns, keywords, ads, etc.
