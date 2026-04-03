select
    order_id_x,
    user_name as user_id_x,
    order_status_x,
    DATETIME(order_date, "Europe/Paris") AS order_created_at_y,
    DATETIME(order_approved_date, "Europe/Paris") AS order_approved_at_y,
    DATETIME(pickup_date, "Europe/Paris") AS picked_up_at_y,
    DATETIME(delivered_date, "Europe/Paris") AS delivered_at_y,
    DATETIME(estimated_time_delivery, "Europe/Paris") AS estimated_time_delivery_y
from {{ source('sales_database', 'order') }}