# Validate Pending Google Ads Changes

Validates the pending changes in `pending_changes.json` against the Google Ads API without executing them (dry-run).

1. First, read `pending_changes.json` and display a brief summary to the user (number of operations by type).

2. POST both files to the API (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/google-ads/validate-changes?pluginVersion=1.8.0" -F "config=@config.json" -F "pendingChanges=@pending_changes.json"
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

3. After the API responds:
   - If validation succeeded: confirm the changes are ready for execution with `/google-ads:execute-changes`.
   - If validation failed: show the errors, explain what went wrong, and suggest fixes for the pending_changes.json.
