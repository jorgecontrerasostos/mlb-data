select
    id as team_id,
    teamCode as team_code,
    abbreviation,
    teamName as team_name,
    locationName as location_name,
    clubName as club_name,
    venue.id as venue_id,
    venue.name as venue_name,
    league.id as league_id,
    league.name as league_name,
    division.id as division_id,
    division.name as division_name
from {{ source('bronze', 'teams') }}