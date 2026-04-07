SELECT
  concat(product_id,'_',store_id) as product_store_id,
  store_id,
  product_id,
  quantity as stock_to_date
FROM {{source('local_bike','stocks')}}
