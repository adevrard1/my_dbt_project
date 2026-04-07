

SELECT
  order_id,
  customer_id,
  cast(order_status as string) as order_status,
  order_date,
  required_date,
  CAST(shipped_date as date) AS shipped_date,
  store_id,
  staff_id
FROM {{source('local_bike','orders')}}