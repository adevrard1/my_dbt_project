SELECT
  cast(concat(order_id,'_',order_item) as string) as order_item_id,
  cast(order_id as string) as order_id,
  cast(item_id as string) as item_id,
  cast(product_id as string) as product_id,
  round(quantity * (list_price - (list_price * discount)),2) as order_item_amount,
  quantity as item_quantity,
  list_price as std_price,
  round(list_price - (list_price * discount),2) as reduced_price,
  discount * 100 as discount_percentage
FROM {{source('local_bike','order_items')}}