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

2. Run the following command (**set Bash timeout to 240000ms** — the server may take up to 230 seconds), substituting the query parameters:

```
curl -s --max-time 230 -o response.zip -X POST "https://api.claudeppc.ai/api/cli/google-ads/get-custom-data?pluginVersion=1.7.0" -F "config=@config.json" -F "name={query_name}" -F "query={GAQL query}"
```

**Parameters:**
- `name`: Short identifier for the query (e.g., `campaign_7d`, `keyword_device`). Used as the output filename.
- `query`: Valid GAQL query string (e.g., `SELECT campaign.name, metrics.clicks FROM campaign`)

3. Extract and clean up:
```
mkdir -p data/custom && unzip -o response.zip -d data/custom && rm response.zip
```

4. Read the results file `data/custom/<query_name>.md` and present the data to the user.

## Example

Query name: `top_keywords`
GAQL: `SELECT ad_group_criterion.keyword.text, metrics.conversions FROM keyword_view WHERE metrics.conversions > 0 ORDER BY metrics.conversions DESC LIMIT 50`

## Notes

- Monetary values in GAQL results are in micros (divide by 1,000,000 for currency)
- Results are saved as markdown tables
- Multiple custom queries can coexist in `data/custom/`
