WITH
  monthly_sales_per_staff AS (
    SELECT
      DATE_TRUNC(order_date, MONTH) AS month_year,
      staff_id,
      staff_name,
      manager_id,
      store_id,
      SUM(total_order_amount) AS total_turnover,
      COUNT(DISTINCT order_id) AS nb_orders
    FROM {{ref('int_local_bike__orders')}}
    GROUP BY 1, 2, 3, 4, 5
  )
  
SELECT
  month_year,
  staff_id,
  staff_name,
  manager_id,
  store_id,
  total_turnover,
  total_turnover / SUM(total_turnover)
    OVER (PARTITION BY month_year) * 100
    AS turnover_contribution,
  ROW_NUMBER()
    OVER (
      PARTITION BY month_year
      ORDER BY total_turnover DESC
    ) AS ranking_staffs_by_turnover_per_month,
  nb_orders
FROM monthly_sales_per_staff