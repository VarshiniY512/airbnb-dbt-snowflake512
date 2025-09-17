{{ config(materialized='view') }}

-- staging model for Airbnb reviews
with raw as (
  select
    -- if the raw source has a review_id, use it; otherwise create a synthetic one
    coalesce(
      try_cast(review_id as int),
      -- fallback synthetic id using hash: (Snowflake HASH function)
      abs(mod(hash(concat(listing_id, reviewer_name, comments, date)), 2147483647))
    ) as review_id,
    try_cast(listing_id as int)     as listing_id,
    reviewer_id,
    reviewer_name,
    comments,
    try_to_date(date)               as review_date
  from {{ source('airbnb', 'reviews') }}
)

select *
from raw
