-- ad-hoc analysis: top listings by number of reviews on full moon dates
select
  l.listing_id,
  l.name,
  l.neighbourhood,
  count(*) as full_moon_review_count
from {{ ref('mart_fullmoon_reviews') }} m
left join {{ ref('dim_listings_cleansed') }} l
  on m.listing_id = l.listing_id
group by 1,2,3
order by full_moon_review_count desc
limit 50
