import dagster as dg
import pandas as pd
import statsapi
from constants import SPORTS_ID


@dg.asset(
    description="MLB schedule data from statsapi",
    key_prefix=["bronze"],
    kinds={"duckdb"},
)
def schedule() -> pd.DataFrame:
    """
    TODO: Check date. Without date param it extracts current date games

    Raises:
        ValueError: _description_

    Returns:
        pd.DataFrame: _description_
    """
    schedule = statsapi.get("schedule", {"sportId": SPORTS_ID})
    if not schedule:
        raise ValueError("No schedule data found from statsapi")
    return pd.DataFrame(schedule["dates"])
