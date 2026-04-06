SELECT
  cast(brand_id as string) as brand_id,
  brand_name
FROM {{source('local_bike','brands')}}
