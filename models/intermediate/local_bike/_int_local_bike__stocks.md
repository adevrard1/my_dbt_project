{% docs int_local_bike__stocks %}
This table captures product inventory information at the store level. Each row represents the stock status of a specific product in a specific store.

Columns:

product_store_id : Unique identifier for the product-store combination.
store_id : Unique identifier of the store.
store_name : Name of the store.
product_id : Unique identifier of the product.
product_name : Name of the product.
stock_to_date : Current stock quantity of the product in the store as of the recorded date.

Purpose:
This table is used for inventory tracking and store-level stock management. It allows monitoring product availability across stores, planning restocking, and analyzing product distribution.
{% enddocs %}