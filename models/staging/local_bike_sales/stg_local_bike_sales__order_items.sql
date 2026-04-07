SELECT
  cast(concat(order_id,'_',item_id) as string) as order_item_id,
  order_id,
  item_id,
  product_id,
  round(quantity * (list_price - (list_price * discount)),2) as order_item_amount,
  quantity as order_item_quantity,
  list_price as std_price,
  round(list_price - (list_price * discount),2) as reduced_price 
FROM {{source('local_bike','order_items')}}