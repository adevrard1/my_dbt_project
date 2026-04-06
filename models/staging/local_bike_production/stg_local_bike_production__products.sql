SELECT
  cast(product_id as string) as product_id,
  product_name,
  cast(brand_id as string) as brand_id,
  cast(category_id as string) as category_id,
  extract (year from cast(concat(model_year, '-01-01') as date)) as model_year,
  list_price as std_price
FROM {{source('local_bike','products')}}
