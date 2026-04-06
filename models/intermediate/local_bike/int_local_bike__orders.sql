with order_sales as (

select 
    order_id, 
    sum(order_item_amount) as total_order_amount,
    sum(order_item_quantity) as total_order_quantity,
    count(distinct item_id) as total_distinct_items
from {{ref('stg_local_bike_sales__order_items')}}
group by order_id

), customers_details as (

select 
    customer_id,
    city as customer_city,
    state as customer_state
from {{ref('stg_local_bike_sales__customers')}}

), staffs_details as (

select
    staff_id,
    concat(first_name,'_',last_name) as staff_name,
    manager_id
from {{ref('stg_local_bike_sales__staffs')}}

), stores_details as (

select 
    store_id,
    store_name,
    city as store_city,
    state as store_state
from {{ref('stg_local_bike_sales__stores')}}
)

select 
    o.order_id,
    o.customer_id,
    customer_state,
    customer_city,
    o.staff_id,
    staff_name,
    manager_id,
    o.store_id,
    store_name,
    store_city,
    store_state,
    order_status,
    required_date,
    shipped_date,
    total_order_amount,
    total_order_quantity,
    total_distinct_items

from {{ref('stg_local_bike_sales__orders')}} as o
left join order_sales os on o.order_id = os.order_id 
left join customers_details cd on o.customer_id = cd.customer_id
left join staffs_details sd on sd.staff_id = o.staff_id
left join stores_details std on std.store_id = o.store_id