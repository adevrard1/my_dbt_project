
 WITH sales AS (
  SELECT
    DATE_TRUNC(order_date, MONTH) AS month_year,
    store_id,
    store_name,
    store_city,
    store_state,
    ROUND(SUM(total_order_amount),2) as total_turnover,
    SUM(total_order_quantity) as total_sales_quantity,
    COUNT(distinct order_id) as nb_orders,
    ROUND(SUM(total_order_amount)/COUNT(distinct order_id),2) as avg_amount_per_order
FROM {{ref('int_local_bike__orders')}}
  GROUP BY 1,2,3,4,5
)

SELECT
    month_year,
    store_id,
    store_name,
    store_city,
    store_state,
    ROUND(total_turnover,2) as total_turnover
    ROUND(total_turnover / SUM(total_turnover)
        OVER (PARTITION BY month_year) * 100,2)
        AS turnover_contribution,
    ROW_NUMBER() OVER (
        PARTITION BY month_year
        ORDER BY total_turnover DESC
        ) AS ranking_turnover_stores_per_month,
    total_sales_quantity,
    nb_orders,
    avg_amount_per_order
FROM sales
ORDER BY month_year DESC, ranking_turnover_stores_per_month