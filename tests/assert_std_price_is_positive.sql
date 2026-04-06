select
    order_item_id,
    std_price
from {{ ref('stg_local_bike_sales__order_items') }}
where std_price <= 0