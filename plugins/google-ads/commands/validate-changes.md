# Validate Pending Google Ads Changes

Validates the pending changes in `pending_changes.json` against the Google Ads API without executing them (dry-run).

1. First, read `pending_changes.json` and display a brief summary to the user (number of operations by type).

2. POST both files to the API (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
curl -s --max-time 230 -X POST "https://api.claudeppc.ai/api/cli/google-ads/validate-changes" -F "config=@config.json" -F "pendingChanges=@pending_changes.json"
```

3. After the API responds:
   - If validation succeeded: confirm the changes are ready for execution with `/google-ads:execute-changes`.
   - If validation failed: show the errors, explain what went wrong, and suggest fixes for the pending_changes.json.
