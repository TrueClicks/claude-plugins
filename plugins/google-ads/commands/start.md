# Start Session

Run this at the start of each session to set up the project.

## Step 1: Display Welcome Banner

Before doing anything else, display the following banner to the user exactly as shown, inside a code block:

```
.
  ██████   ██████   ██████   ██████  ██      ███████       █████  ██████   ██████
 ██       ██    ██ ██    ██ ██       ██      ██           ██   ██ ██   ██ ██
 ██  ███  ██    ██ ██    ██ ██  ███  ██      █████        ███████ ██   ██  █████
 ██    ██ ██    ██ ██    ██ ██    ██ ██      ██           ██   ██ ██   ██      ██
  ██████   ██████   ██████   ██████  ██████  ███████      ██   ██ ██████  ██████
 v20260305.1
```

Display this banner first, with no other text before it. Then proceed to the steps below.

## Step 2: Check Configuration

Check if `config.json` exists in the project root.

- If it **does not exist**: create it with the following content, then tell the user to fill in their credentials and run `/google-ads:start` again. **Stop here.**

```json
{
  "platform": "google-ads",
  "loginCustomerId": 1234567890,
  "clientCustomerId": 1234567890,
  "gptToken": "YOUR-TOKEN-HERE"
}
```

- If it **exists but contains placeholder values** (`YOUR-TOKEN-HERE`, `1234567890`): tell the user to fill in their credentials and run `/google-ads:start` again. **Stop here.**

- If it **exists with real values**: continue to Step 3.

## Step 3: Check Project State

- If `data/` folder **does not exist**: suggest the user runs `/google-ads:get` to download account data.
- If `data/` folder **exists**:
  1. Read `CLAUDE.md` if it exists in the project root — this contains project guidance, data structure docs, and available commands.
  2. Read `data/account/account_summary.md` to load account context.
  3. Give the user a brief summary of the loaded data (account name, number of campaigns, date range).
  4. Suggest running `/google-ads:get` to refresh with the latest data.

## Step 4: Check for Pending Changes

Check if `pending_changes.json` exists in the project root.

- If it exists: read it and display a summary to the user:
  - Total number of operations
  - Breakdown by operation type
  - Suggest running `/google-ads:validate-changes` to validate or `/google-ads:execute-changes` to apply them
- If it does not exist: skip this step silently (no message needed).

## Step 5: Ready

Tell the user the session is ready and they can:
- Ask questions about their account
- Request analysis or audits
- Plan changes to campaigns, keywords, ads, etc.
