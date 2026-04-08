select 
    order_id,
    order_date,
    customer_id,
    customer_name,
    customer_state,
    customer_city,
    staff_id,
    staff_name,
    manager_id,
    store_id,
    store_name,
    store_city,
    store_state,
    MAX(order_status) as order_status,
    CASE WHEN MAX(order_status)  <> '4' then true else False end as order_not_delivered,
    MAX(required_date) as required_date,
    MAX(shipped_date) as shipped_date,
    CASE WHEN MAX(shipped_date) > MAX(required_date)  then true else False end as shipment_is_late,
    SUM(total_order_amount) as total_order_amount,
    SUM(total_order_quantity) as total_order_quantity
from {{ref('int_local_bike__orders')}}  
group by 1,2,3,4,5,6,7,8,9, 10, 11, 12, 13