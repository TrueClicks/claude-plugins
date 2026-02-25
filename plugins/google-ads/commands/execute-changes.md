# Execute Pending Google Ads Changes

Executes the pending changes in `pending_changes.json` in the live Google Ads account.

## IMPORTANT: User Confirmation Required

**Before running the execution script, you MUST ask the user for confirmation using the AskUserQuestion tool:**

Ask the user:
- Question: "This will apply all pending changes to your live Google Ads account. Are you sure you want to execute these changes?"
- Header: "Confirm"
- Options:
  - "Yes, execute changes" — Proceed with execution
  - "No, cancel" — Abort the operation

**Only proceed if the user explicitly confirms. If the user selects "No" or any other option, abort and do not run the script.**

## Execution Steps

1. Read `pending_changes.json` and display a summary to the user:
   - Total number of operations
   - Breakdown by operation type
   - Estimated budget impact (if applicable)

2. **ASK FOR USER CONFIRMATION** (as described above).
   - If user does not confirm, abort immediately.

3. If user confirms, run the execution script:
```
pwsh -ExecutionPolicy Bypass -File scripts/google-ads-execute-changes.ps1
```

The script reads `config.json` and `pending_changes.json`, calls the execution API, archives results to `change-history/`, and removes `pending_changes.json`.

4. After the script completes:
   - If successful: summarize what was applied, note the change history file path, and recommend running `/google-ads:get` to refresh local data.
   - If partially failed: explain which operations succeeded and which failed, and suggest next steps.
   - If completely failed: show the errors and suggest fixes.
