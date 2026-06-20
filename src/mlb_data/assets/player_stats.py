import dagster as dg
import pandas as pd
import statsapi
import json
import time

from .schedule import daily_partition
from constants import SPORTS_ID


@dg.asset(
    description="MLB stats data from statsapi",
    key_prefix=["bronze"],
    kinds={"duckdb"},
    partitions_def=daily_partition,
    metadata={"partition_expr": "date"},
)
def player_stats(context: dg.AssetExecutionContext) -> pd.DataFrame:
    date = context.partition_key
    player_stats_data = statsapi.get("sports_players", {"season": date.split("-")[0]})

    if not player_stats_data:
        raise ValueError("Player Stats retrieval failed.")

    players = player_stats_data.get("people", [])
    hydrate = (
        "stats(group=[hitting,pitching],"
        + "type=season,"
        + f"sportId={SPORTS_ID},"
        + f"season={date.split('-')[0]}),"
        + "currentTeam"
    )
    stat_rows = []

    for player in players:
        context.log.info("Getting player stats")
        try:
            stats = statsapi.get(
                "person", params={"personId": player.get("id", ""), "hydrate": hydrate}
            )
            time.sleep(0.3)
            stat_rows.append(
                {
                    "player_id": player.get("id"),
                    "date": date,
                    "stats": json.dumps(stats),
                }
            )
        except Exception as e:
            context.log.error(f"Could not retrieve player stats: {e}")

    return pd.DataFrame(stat_rows, columns=["player_id", "date", "stats"])
