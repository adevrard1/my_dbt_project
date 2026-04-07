SELECT
  product_id,
  product_name,
  brand_id,
  category_id,
  extract (year from cast(concat(model_year, '-01-01') as date)) as model_year,
  list_price as std_price
FROM {{source('local_bike','products')}}
