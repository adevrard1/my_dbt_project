{{ config(
materialized='table',
tags=['daily']
) }}
select
neighbourhood_cleansed,
room_type,
count(id) as total_listings,
avg(price) as avg_price,
from {{ ref('stg__airbnb__listings') }}
group by
1,2