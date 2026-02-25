# Fetch Custom Google Ads Data

Runs a custom GAQL query to fetch data not available in the standard export.

## When to Use

Use this when the data in `data/account/` and `data/performance/` is insufficient and you need:
- Different date ranges
- Metrics not included in the standard export
- Data at different aggregation levels
- Specific segments or filters

## Steps

1. Construct a valid GAQL query for the data needed.

2. Run the script with the query name and GAQL:
```
pwsh -ExecutionPolicy Bypass -File scripts/google-ads-get-custom.ps1 -Name "<query_name>" -Query "<GAQL query>"
```

**Parameters:**
- `-Name`: Short identifier for the query (e.g., `campaign_7d`, `keyword_device`). Used as the output filename.
- `-Query`: Valid GAQL query string (e.g., `SELECT campaign.name, metrics.clicks FROM campaign`)

3. The script saves results to `data/custom/<query_name>.md`

4. Read the results file and present the data to the user.

## Example

```
pwsh -ExecutionPolicy Bypass -File scripts/google-ads-get-custom.ps1 -Name "top_keywords" -Query "SELECT ad_group_criterion.keyword.text, metrics.conversions FROM keyword_view WHERE metrics.conversions > 0 ORDER BY metrics.conversions DESC LIMIT 50"
```

## Notes

- Monetary values in GAQL results are in micros (divide by 1,000,000 for currency)
- Results are saved as markdown tables
- Multiple custom queries can coexist in `data/custom/`
