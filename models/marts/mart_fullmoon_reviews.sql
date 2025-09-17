{{ config(materialized='table') }}

with reviews as (
  select
    review_id,
    listing_id,
    reviewer_name,
    comments,
    review_date
  from {{ ref('stg_reviews') }}
),

full_moons as (
  -- this assumes you have a seed called full_moon_dates.csv which becomes a table named full_moon_dates
  select
    to_date(full_moon_date) as full_moon_date
  from {{ ref('full_moon_dates') }}
)

select
  r.review_id,
  r.listing_id,
  r.reviewer_name,
  r.comments,
  r.review_date,
  date_trunc('day', r.review_date) as review_day,
  f.full_moon_date
from reviews r
inner join full_moons f
  on date_trunc('day', r.review_date) = f.full_moon_date
