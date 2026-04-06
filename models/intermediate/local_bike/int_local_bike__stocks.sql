SELECT
  product_store_id,
  s.store_id,
  store_name,
  s.product_id,
  product_name,
  stock_to_date
-- avg_daily_sales_last_30d,
-- estimated_nb_days_before_rupture,
-- estimated_rupture_date,
-- status_of_stock,
-- nb_orders_waiting,
-- nb_stock_to_date_vs_nb_orders_waiting
FROM {{ref('stg_local_bike_production__stocks')}} s 
LEFT JOIN {{ref('stg_local_bike_sales__stores')}} st
  ON s.store_id = st.store_id
LEFT JOIN
  {{ref('stg_local_bike_production__products')}} p
  ON s.product_id = p.product_id
