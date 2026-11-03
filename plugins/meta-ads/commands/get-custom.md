# Fetch Custom Meta Ads Data

Runs a custom Meta Marketing API (Graph API) read query to fetch exactly the data needed.

## When to Use

Use this when the data already in `data/custom/` is insufficient and you need:
- Different entities (audiences, activities, creatives, ...)
- Different fields, date ranges, or breakdowns
- Data at a different level (account, campaign, adset, ad)
- Specific filters

## Steps

1. **Read `docs/CUSTOM_QUERY.md` first** — it has the full parameter reference, field expansion syntax, data gotchas, and ready-made recipes. If it does not exist, run `/meta-ads:get` first to download the workspace.

2. Construct the query: a relative Graph API `path` and one JSON object of `params`. Never URL-encode anything and never include `access_token` — the server handles auth, the API version, encoding, and paging.

3. Run the following command (**set Bash timeout to 240000ms** — the server may take up to 230 seconds):

```
mkdir -p tmp && curl -s --max-time 230 -o tmp/response.zip -D tmp/response_headers.txt -X POST "https://api.claudeppc.ai/api/cli/meta-ads/get-custom-data?pluginVersion=1.0.0" -F "config=@config.json" -F "name={query_name}" -F "path={graph_path}" -F 'params={json_object}'
```

Check `tmp/response_headers.txt` for a line starting with `X-Plugin-Update:`. If found, display its value to the user as a notice. Then delete the headers file: `rm -f tmp/response_headers.txt`.

**Parameters:**
- `name`: Short descriptive identifier (e.g., `paused-campaigns`, `adset-targeting`). Used as the output filename; refetching with the same name overwrites the previous result.
- `path`: Relative Graph path, e.g. `act_{AD_ACCOUNT_ID}/campaigns` (use the `adAccountId` from `config.json`), `{CAMPAIGN_ID}/adsets`, or `act_{AD_ACCOUNT_ID}/insights`.
- `params`: One JSON object of Graph query parameters (`fields`, `filtering`, `level`, `date_preset`, `breakdowns`, `limit`, ...).

4. Extract and clean up:
```
unzip -o tmp/response.zip -d data && rm tmp/response.zip
```

5. Read `data/custom/{query_name}.jsonl` (one JSON object per line) and present the data to the user. Prefer analyzing with code: `pandas.read_json("file.jsonl", lines=True)` or `jq`.

## Example

Query name: `top-spending-adsets`
Path: `act_{AD_ACCOUNT_ID}/insights`
Params: `{"level":"adset","fields":"adset_name,campaign_name,spend,impressions,clicks,actions","date_preset":"last_30d","limit":500}`

## Notes

- Insights metric values come back as **strings** — convert before math.
- Budgets are in **cents** (minor units); insights `spend` is in **whole currency units**.
- If `data/custom/{query_name}.TRUNCATED.txt` exists, the result is incomplete: never analyze it as the full dataset — refetch with a narrower query.
- Multiple custom queries can coexist in `data/custom/`.
