import pytest
from datetime import datetime, timedelta

from mlb_data.jobs.bronze_partitioned import _target_partition_key

def test_target_partition_key():
    date = datetime(2026, 6, 20, 0, 0,)
    assert _target_partition_key(date) == (date - timedelta(days=1)).strftime("%Y-%m-%d")