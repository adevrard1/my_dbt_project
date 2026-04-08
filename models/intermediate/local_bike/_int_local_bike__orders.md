{% docs int_local_bike__orders %}

This table consolidates order information at a product level along with related customer, staff, and store details, and includes aggregated order metrics. Each row represents a single order.

Columns:

order_id : Unique identifier for the order.
order_date : Date when the order was placed.
product_id : Unique identifier for each product. 
customer_id : Unique identifier of the customer who placed the order.
customer_name : Name of the customer.
customer_state : State/region of the customer.
customer_city : City of the customer.
staff_id : Unique identifier of the staff member handling the order.
staff_name : Name of the staff member responsible for the order.
manager_id : Identifier of the manager supervising the staff member.
store_id : Unique identifier of the store where the order was processed.
store_name : Name of the store.
store_city : City of the store.
store_state : State/region of the store.
order_status : Current status of the order (1 to 4 ).
required_date : Date by which the order is required to be delivered.
shipped_date : Actual date the order was shipped.
total_order_amount : Total monetary value of the order.
total_order_quantity : Total number of items in the order.

Purpose:
This table is designed for sales analysis, order tracking, and performance reporting, combining detailed transactional data with customer, staff, and store context. It can be used to measure revenue, order volume, and operational efficiency at multiple levels (customer, staff, store).
{% enddocs %}