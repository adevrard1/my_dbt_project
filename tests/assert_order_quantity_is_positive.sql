select
    order_id,
    sum(order_item_quantity) as total_quantity
from {{ ref('stg_local_bike_sales__order_items') }}
group by order_id
having total_quantity < 0