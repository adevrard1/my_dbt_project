SELECT
  concat(product_id,'_',store_id) as product_store_id,
  cast(store_id as string) as store_id,
  cast(product_id as string) as product_id,
  quantity as stock_to_date
FROM {{source('local_bike','stocks')}}
