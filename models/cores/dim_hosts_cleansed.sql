{{ config(materialized='table') }}

-- cleansed hosts dimension: latest record per host_id
with ranked as (
  select
    host_id,
    host_name,
    is_superhost,
    created_at,
    updated_at,
    row_number() over (
      partition by host_id
      order by coalesce(updated_at, created_at) desc
    ) as rn
  from {{ ref('stg_hosts') }}
)

select
  host_id,
  host_name,
  is_superhost,
  created_at,
  updated_at
from ranked
where rn = 1
