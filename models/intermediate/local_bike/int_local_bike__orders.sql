{{ config(
    cluster_by= 'order_date'
)}}


with order_sales as (

select 
    order_id, 
    product_id,
    ROUND(sum(order_item_amount),2) as total_order_amount,
    sum(order_item_quantity) as total_order_quantity,
    count(distinct item_id) as total_distinct_items
from {{ref('stg_local_bike_sales__order_items')}}
group by 
    order_id,
    product_id

), customers_details as (

select 
    customer_id,
    customer_name,
    customer_city,
    customer_state
from {{ref('stg_local_bike_sales__customers')}}

), staffs_details as (

select
    staff_id,
    staff_name,
    manager_id
from {{ref('stg_local_bike_sales__staffs')}}

), stores_details as (

select 
    store_id,
    store_name,
    store_city,
    store_state
from {{ref('stg_local_bike_sales__stores')}}
)

select 
    o.order_id,
    o.order_date,
    os.product_id,
    o.customer_id,
    cd.customer_name,
    cd.customer_state,
    cd.customer_city,
    o.staff_id,
    sd.staff_name,
    sd.manager_id,
    o.store_id,
    std.store_name,
    std.store_city,
    std.store_state,
    o.order_status,
    o.required_date,
    o.shipped_date,
    os.total_order_amount,
    os.total_order_quantity

from {{ref('stg_local_bike_sales__orders')}} as o
left join order_sales os on o.order_id = os.order_id 
left join customers_details cd on o.customer_id = cd.customer_id
left join staffs_details sd on sd.staff_id = o.staff_id
left join stores_details std on std.store_id = o.store_id