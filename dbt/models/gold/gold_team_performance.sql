with home_perspective as (
    select
        game_pk,
        game_guid,
        game_date,
        game_status,
        home_team_id,
        home_team_name,
        home_team_score,
        case
            when winner = home_team_name then true
            else false
        end::boolean as home_team_win,
        true as is_home
    from {{ ref('silver_schedule') }}
    where game_status = 'F'
),
away_perspective as (
    select
        game_pk,
        game_guid,
        game_date,
        game_status,
        away_team_id,
        away_team_name,
        away_team_score,
        case
            when winner = away_team_name then true
            else false
        end::boolean as away_team_win,
        false as is_home
    from {{ ref('silver_schedule') }}
    where game_status = 'F'
)
select
    game_pk,
    game_guid,
    game_date,
    game_status,
    team_id,
    team_name,
    team_score,
    team_win,
    is_home
from (
    select
        game_pk,
        game_guid,
        game_date,
        game_status,
        home_team_id as team_id,
        home_team_name as team_name,
        home_team_score as team_score,
        home_team_win as team_win,
        is_home
    from home_perspective

    union all

    select
        game_pk,
        game_guid,
        game_date,
        game_status,
        away_team_id as team_id,
        away_team_name as team_name,
        away_team_score as team_score,
        away_team_win as team_win,
        is_home
    from away_perspective
) as team_performance