import dagster as dg
from dagster_dbt import DbtCliResource
from .assets.teams import teams
from .assets.standings import standings
from .assets.schedule import schedule
from .assets.game_feed import game_feed
from .resources.duckdb import duckdb_io_manager
from .assets.dbt import dbt_models

defs = dg.Definitions(
    assets=[teams, schedule, standings, game_feed, dbt_models],
    resources={
        "io_manager": duckdb_io_manager,
        "dbt": DbtCliResource(project_dir="dbt/"),
    },
)
