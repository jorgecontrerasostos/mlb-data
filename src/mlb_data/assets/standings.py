import dagster as dg
import pandas as pd
import statsapi


@dg.asset(
    description="MLB standings data from statsapi",
    key_prefix=["bronze"],
    kinds={"duckdb"},
)
def standings() -> pd.DataFrame:
    standings = statsapi.get("standings", {"leagueId": "103,104"})
    if not standings:
        raise ValueError("No standings data found from statsapi")
    return pd.DataFrame(standings["records"])
