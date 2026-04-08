{% docs mrt_orders_management %}

This table contains detailed information about customer orders, including customer data, staff and store information, order status, and aggregated metrics related to each order.

Order Information
order_id: Unique identifier for each order
order_date: Date when the order was placed
order_status: Current status of the order
required_date: Expected delivery date
shipped_date: Actual shipping date
shipment_is_late: Boolean flag indicating whether the order was shipped after the required date

Customer Information
customer_id: Unique identifier for the customer
customer_name: Full name of the customer
customer_state: State of the customer
customer_city: City of the customer

Staff Information
staff_id: Identifier of the staff member handling the order
staff_name: Name of the staff member
manager_id: Identifier of the staff member’s manager

Store Information
store_id: Identifier of the store fulfilling the order
store_name: Name of the store
store_city: City where the store is located
store_state: State where the store is located

Order Metrics
total_order_amount: Total monetary value of the order
total_order_quantity: Total number of items in the order
total_distinct_items: Number of distinct products included in the order

{% enddocs %}

