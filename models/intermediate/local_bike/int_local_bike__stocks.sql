SELECT
  s.store_id,
  SUM(s.stock_to_date) as stock_to_date
FROM {{ref('stg_local_bike_production__stocks')}} s 
LEFT JOIN {{ref('stg_local_bike_sales__stores')}} st
  ON s.store_id = st.store_id
GROUP BY 
  s.store_id
