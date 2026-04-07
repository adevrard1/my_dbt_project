SELECT
  product_store_id,
  s.store_id,
  store_name,
  s.product_id,
  product_name,
  stock_to_date
FROM {{ref('stg_local_bike_production__stocks')}} s 
LEFT JOIN {{ref('stg_local_bike_sales__stores')}} st
  ON s.store_id = st.store_id
LEFT JOIN
  {{ref('stg_local_bike_production__products')}} p
  ON s.product_id = p.product_id
