# Validate Pending Google Ads Changes

Validates the pending changes in `pending_changes.json` against the Google Ads API without executing them (dry-run).

1. First, read `pending_changes.json` and display a brief summary to the user (number of operations by type).

2. Run the validation script:

```
pwsh -ExecutionPolicy Bypass -File scripts/google-ads-validate-changes.ps1
```

The script reads `config.json` and `pending_changes.json`, calls the validation API, and displays the results.

3. After the script completes:
   - If validation succeeded: confirm the changes are ready for execution with `/google-ads:execute-changes`.
   - If validation failed: show the errors, explain what went wrong, and suggest fixes for the pending_changes.json.
