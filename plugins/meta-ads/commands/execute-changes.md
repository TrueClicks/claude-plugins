# Execute Pending Meta Ads Changes

Executes the pending changes in `pending_changes.json` in the live Meta ad account.

## IMPORTANT: User Confirmation Required

**Before running the execution, you MUST ask the user for confirmation using the AskUserQuestion tool:**

Ask the user:
- Question: "This will apply all pending changes to your live Meta Ads account. Are you sure you want to execute these changes?"
- Header: "Confirm"
- Options:
  - "Yes, execute changes" — Proceed with execution
  - "No, cancel" — Abort the operation

**Only proceed if the user explicitly confirms. If the user selects "No" or any other option, abort and do not run the command.**

## Execution Steps

1. Read `pending_changes.json` and display a summary to the user:
   - Total number of operations
   - Breakdown by operation type
   - Estimated budget impact (if applicable; budget fields are in cents — 5000 means 50.00)
   - Remind the user that created and copied entities always start PAUSED, and campaigns cannot be activated from here

2. **ASK FOR USER CONFIRMATION** (as described above).
   - If user does not confirm, abort immediately.

3. If user confirms, POST both files to the API (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/meta-ads/execute-changes?pluginVersion=1.0.0" -F "config=@config.json" -F "pendingChanges=@pending_changes.json"
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

4. If the API call succeeded, archive the results:
   - Create `change-history/` directory if it doesn't exist
   - Save `pending_changes.json` with added `status`, `executed_at`, and `execution_results` fields to `change-history/changes-{YYYYMMDD-HHmm}.json`
   - Delete `pending_changes.json`

5. After the API responds:
   - If successful: summarize what was applied, including the new entity IDs for create/copy operations, note the change history file path, and recommend refetching the affected data with `/meta-ads:get-custom`.
   - If partially failed: explain per operation which succeeded, which failed, and which were not executed (status `NotExecuted` — operations after a failure may be skipped), and suggest next steps.
   - If completely failed: show the errors and suggest fixes.
