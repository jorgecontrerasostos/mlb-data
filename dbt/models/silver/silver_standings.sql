select
    standingsType as standings_type,
    league.id as league_id,
    division.id as division_id,
    lastUpdated as last_updated,
    json_extract_string(record, '$.team.name') as team_name,
    json_extract_string(record, '$.team.id') as team_id,
    json_extract_string(record, '$.leagueRecord.wins') as wins,
    json_extract_string(record, '$.leagueRecord.losses') as losses,
    json_extract_string(record, '$.leagueRecord.pct') as pct,
    json_extract_string(record, '$.gamesBack') as games_back,
    json_extract_string(record, '$.wildCardGamesBack') as wild_card_games_back
from {{ source('bronze', 'standings') }},
unnest(from_json(teamRecords, '["json"]')) as t(record)