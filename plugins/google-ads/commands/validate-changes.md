# Validate Pending Google Ads Changes

Validates the pending changes in `pending_changes.json` against the Google Ads API without executing them (dry-run).

1. First, read `pending_changes.json` and display a brief summary to the user (number of operations by type).

2. Read `config.json` to get `loginCustomerId`, `clientCustomerId`, and `gptToken`.

3. POST the `pending_changes.json` file directly as the request body, with credentials in the URL:

```
curl -s -X POST "https://api.gaql.app/api/cli/google-ads/validate-changes?loginCustomerId={loginCustomerId}&clientCustomerId={clientCustomerId}&gptToken={gptToken}" -H "Content-Type: application/json" -d @pending_changes.json
```

4. After the API responds:
   - If validation succeeded: confirm the changes are ready for execution with `/google-ads:execute-changes`.
   - If validation failed: show the errors, explain what went wrong, and suggest fixes for the pending_changes.json.
