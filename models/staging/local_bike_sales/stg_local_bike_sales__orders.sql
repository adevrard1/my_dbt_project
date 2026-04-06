SELECT
  CAST(order_id AS string) AS order_id,
  CAST(customer_id AS string) AS customer_id,
  CAST(order_status AS string) AS order_status,
  order_date,
  required_date,
  shipped_date,
  CAST(store_id AS string) AS store_id,
  CAST(staff_id AS string) AS staff_id
FROM {{source('local_bike','orders')}}