SELECT
  EXTRACT(year FROM order_date) AS year,
  EXTRACT(month FROM order_date) AS month,
  round(sum(total_order_amount), 2) AS total_sales_amount,
  sum(total_order_quantity) AS total_sales_quantity,
  COUNT(DISTINCT order_id) AS nb_commandes
-- top_store_of_the_month,
-- top_product_of_the_month,
-- top_staff_of_the_month,
FROM `databird-488418.dbt_aevrard_int_local_bike.int_local_bike__orders`
GROUP BY
  EXTRACT(year FROM order_date),
  EXTRACT(month FROM order_date)
ORDER BY
  EXTRACT(year FROM order_date) DESC,
  EXTRACT(month FROM order_date) DESC