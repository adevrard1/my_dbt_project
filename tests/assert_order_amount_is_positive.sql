select
    order_id,
    sum(order_item_amount) as total_amount
from {{ ref('stg_local_bike_sales__order_items') }}
group by order_id
having total_amount < 0