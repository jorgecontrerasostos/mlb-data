import dagster as dg
from .assets.teams import teams
from .assets.standings import standings
from .assets.schedule import schedule
from .resources.duckdb import duckdb_io_manager

defs = dg.Definitions(
    assets=[teams, schedule, standings], resources={"io_manager": duckdb_io_manager}
)
