with silver_schedule as (
    select
        json_extract_string(game, '$.gamePk') as game_pk,
        json_extract_string(game, '$.gameGuid') as game_guid,
        json_extract_string(game, '$.officialDate') as game_date,
        json_extract_string(game, '$.status.statusCode') as game_status,
        json_extract_string(game, '$.teams.away.team.id') as away_team_id,
        json_extract_string(game, '$.teams.away.team.name') as away_team_name,
        json_extract_string(game, '$.teams.away.score')::integer as away_team_score,
        json_extract_string(game, '$.teams.home.team.id') as home_team_id,
        json_extract_string(game, '$.teams.home.team.name') as home_team_name,
        json_extract_string(game, '$.teams.home.score')::integer as home_team_score,
        json_extract_string(game, '$.venue.id') as venue_id,
        json_extract_string(game, '$.venue.name') as venue_name,
        json_extract_string(game, '$.status.abstractGameState') as game_state
    from {{ source('bronze', 'schedule') }},
    unnest(from_json(games, '["json"]')) as t(game)
)

select
    game_pk,
    game_guid,
    game_date,
    game_status,
    away_team_id,
    away_team_name,
    away_team_score,
    home_team_id,
    home_team_name,
    home_team_score,
    venue_id,
    venue_name,
    game_state,
    case
        when home_team_score > away_team_score then home_team_name
        when away_team_score > home_team_score then away_team_name
        else null
    end as winner,
    case
        when game_status = 'F' then 'Final'
        when game_status = 'DR' then 'Delayed Rain'
        when game_status = 'DI' then 'Delayed Inclement Weather'
        when game_status = 'FR' then 'Finished Early, Rain'
        else 'Other'
    end as game_status_desc
from silver_schedule