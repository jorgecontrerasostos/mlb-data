select
    t.league_name as league,
    t.division_name as division,
    t.team_name as team,
    s.wins::int as wins,
    s.losses::int as losses,
    s.pct::float as pct,
    case when s.games_back = '-' then 0::varchar
    else s.games_back
    end::float as games_back
from {{ ref('silver_teams') }} as t
join {{ ref('silver_standings') }} as s on t.team_id = s.team_id
order by t.league_name, t.division_name, s.pct desc