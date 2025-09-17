{{ config(materialized='view') }}

-- staging model for Airbnb listings
with raw as (
  select
    id                          as listing_id,
    listing_url,
    name,
    neighbourhood,
    room_type,
    -- remove $ and commas from price then cast
    TRY_CAST(REGEXP_REPLACE(price, '[$,]', '') AS FLOAT) as price,
    TRY_CAST(minimum_nights AS INT)                  as minimum_nights,
    TRY_CAST(host_id AS INT)                         as host_id,
    TRY_TO_TIMESTAMP(created_at)                     as created_at,
    TRY_TO_TIMESTAMP(updated_at)                     as updated_at
  from {{ source('airbnb', 'listings') }}
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
  created_at,
  updated_at
from raw
