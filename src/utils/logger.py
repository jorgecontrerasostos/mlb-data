import dagster as dg

def get_app_logger(name: str | None = None):
    return dg.get_dagster_logger(name=name)