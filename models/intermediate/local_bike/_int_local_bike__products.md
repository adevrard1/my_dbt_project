{% docs int_local_bike__products %}

This table captures product-level sales and pricing information along with inventory and product attributes. Each row represents a summary of a product's sales on a specific date or month.

Columns:

date : The specific date of the sales record.
month_year : The month and year corresponding to the sales record (useful for monthly aggregation).
product_id : Unique identifier for the product.
product_name : Name of the product.
brand_name : Brand associated with the product.
category_name : Category of the product (e.g., electronics, furniture).
model_year : Manufacturing or model year of the product.
start_price : Base price of the product before discounts.
total_amount : Total sales amount for the product (rounded to 2 decimal places).
total_quantity : Total number of units sold for the product.
final_price : Average price per unit sold after any discounts, calculated as total_amount / total_quantity (rounded to 2 decimals).
price_gap_after_discount : Difference between the final price and the start price, showing the effective discount applied (rounded to 2 decimals).
stock_to_date : Available inventory of the product today.

Purpose:
This table is intended for sales performance analysis, pricing analysis, and inventory monitoring at the product level. It allows tracking how discounts impact revenue, evaluating brand/category performance, and monitoring stock levels over time.
{% enddocs %}