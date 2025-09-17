{{ config(materialized='table') }}

-- lightweight SCD pattern: compute 'is_current' flag per listing_id based on latest timestamp
with src as (
  select
    listing_id,
    listing_url,
    name,
    neighbourhood,
    room_type,
    price,
    minimum_nights,
    host_id,
    coalesce(updated_at, created_at) as effective_ts
  from {{ ref('stg_listings') }}
),

ranked as (
  select
    *,
    row_number() over (
      partition by listing_id
      order by effective_ts desc
    ) as rn
  from src
)

select
  listing_id,
  listing_url,
  name,
  neighbourhood,
  room_type,
  price,
  minimum_nights,
  host_id,
  effective_ts as effective_at,
  case when rn = 1 then true else false end as is_current
from ranked
