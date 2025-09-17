{{ config(materialized='view') }}

-- staging model for Airbnb hosts
with raw as (
  select
    id                                  as host_id,
    name                                as host_name,
    lower(trim(is_superhost))            as is_superhost_raw,
    TRY_TO_TIMESTAMP(created_at)        as created_at,
    TRY_TO_TIMESTAMP(updated_at)        as updated_at
  from {{ source('airbnb', 'hosts') }}
)

select
  host_id,
  host_name,
  case
    when is_superhost_raw in ('t','true','yes','y','1') then true
    else false
  end as is_superhost,
  created_at,
  updated_at
from raw
where host_id is not null
