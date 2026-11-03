# Validate Pending Meta Ads Changes

Validates the pending changes in `pending_changes.json` against the Meta Marketing API without executing them (dry-run). The server checks the fields locally, verifies every referenced ID (existence, account ownership, entity kind), and runs the API's own validation where possible.

1. First, read `pending_changes.json` and display a brief summary to the user (number of operations by type). The operation reference is in `docs/PENDING_CHANGES.md`; if it does not exist, run `/meta-ads:get` first.

2. POST both files to the API (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/meta-ads/validate-changes?pluginVersion=1.0.0" -F "config=@config.json" -F "pendingChanges=@pending_changes.json"
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

3. After the API responds:
   - If validation succeeded: confirm the changes are ready for execution with `/meta-ads:execute-changes`.
   - If validation failed: show the errors per operation, explain what went wrong, and suggest fixes for the pending_changes.json. One invalid operation rejects the whole batch — nothing runs until all operations validate.
