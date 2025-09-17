{{ config(materialized='table') }}

-- listings dimension enriched with host info
with listings as (
  select
    listing_id,
    listing_url,
    name,
    neighbourhood,
    room_type,
    price,
    minimum_nights,
    host_id,
    created_at,
    updated_at
  from {{ ref('stg_listings') }}
),

hosts as (
  select
    host_id,
    host_name,
    is_superhost
  from {{ ref('dim_hosts_cleansed') }}
)

select
  l.listing_id,
  l.listing_url,
  l.name,
  l.neighbourhood,
  l.room_type,
  l.price,
  l.minimum_nights,
  l.host_id,
  h.host_name,
  h.is_superhost,
  l.created_at,
  l.updated_at
from listings l
left join hosts h
  on l.host_id = h.host_id
