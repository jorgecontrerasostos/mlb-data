import dagster as dg
import pandas as pd
import statsapi


@dg.asset(description="MLB teams data from statsapi", key_prefix=["bronze"])
def teams() -> pd.DataFrame:
    teams = statsapi.get("teams", {"sportId": 1})
    if not teams:
        raise ValueError("No teams data found from statsapi")
    return pd.DataFrame(teams["teams"])
