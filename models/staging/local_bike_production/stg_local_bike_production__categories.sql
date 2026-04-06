SELECT
  cast(category_id as string) as category_id,
  category_name
FROM {{source('local_bike','categories')}}