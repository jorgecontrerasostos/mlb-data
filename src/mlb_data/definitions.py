import dagster as dg
from .assets.teams import teams, schedule
from .resources.duckdb import duckdb_io_manager

defs = dg.Definitions(assets=[teams, schedule], resources={"io_manager": duckdb_io_manager})
