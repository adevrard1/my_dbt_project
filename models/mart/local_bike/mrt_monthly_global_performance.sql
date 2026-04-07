WITH
  calendar AS (
    SELECT
      month_year
    FROM
      (
        SELECT
          DATE_TRUNC(MIN(order_date), MONTH) AS min_date,
          DATE_TRUNC(MAX(order_date), MONTH) AS max_date
        FROM `databird-488418.dbt_aevrard_int_local_bike.int_local_bike__orders`
      ),
      UNNEST(
        GENERATE_DATE_ARRAY(min_date, max_date, INTERVAL 1 MONTH)) AS month_year
  ),
  monthly_sales AS (
    SELECT
      DATE_TRUNC(order_date, MONTH) AS month_year,
      ROUND(SUM(total_order_amount), 2) AS total_sales_amount,
      SUM(total_order_quantity) AS total_sales_quantity,
      COUNT(DISTINCT order_id) AS nb_orders,
      SAFE_DIVIDE(SUM(total_order_amount),COUNT(DISTINCT order_id)) as avg_order_value
    FROM `databird-488418.dbt_aevrard_int_local_bike.int_local_bike__orders`
    GROUP BY
      DATE_TRUNC(order_date, MONTH)
  ),
  precedent_monthly_sales AS (
    SELECT
      month_year,
      LAG(total_sales_amount)
        OVER (ORDER BY month_year) AS precedent_month_total_sales_amount,
      LAG(total_sales_quantity)
        OVER (ORDER BY month_year) AS precedent_month_total_sales_quantity,
      LAG(nb_orders)
        OVER (ORDER BY month_year) AS precedent_month_nb_orders,
      LAG(avg_order_value)
        OVER (ORDER BY month_year) AS precedent_month_avg_order_value
    FROM monthly_sales
  ),
  lastyear_monthly_sales AS (
    SELECT
      month_year,
      LAG(total_sales_amount, 11)
        OVER (ORDER BY month_year) AS lastyear_month_total_sales_amount,
      LAG(total_sales_quantity, 11)
        OVER (ORDER BY month_year) AS lastyear_month_total_sales_quantity,
      LAG(nb_orders, 11)
        OVER (ORDER BY month_year) AS lastyear_month_nb_orders,
      LAG(avg_order_value, 11)
        OVER (ORDER BY month_year) AS lastyear_month_avg_order_value
    FROM monthly_sales
  )


SELECT
  c.month_year,
  total_sales_amount,
  precedent_month_total_sales_amount,
  lastyear_month_total_sales_amount,
  total_sales_quantity,
  precedent_month_total_sales_quantity,
  lastyear_month_total_sales_quantity,
  nb_orders,
  precedent_month_nb_orders,
  lastyear_month_nb_orders,
  avg_order_value,
  precedent_month_avg_order_value,
  lastyear_month_avg_order_value

FROM calendar c
LEFT JOIN monthly_sales ms ON c.month_year = ms.month_year
LEFT JOIN precedent_monthly_sales pms ON c.month_year = pms.month_year
LEFT JOIN lastyear_monthly_sales lms ON c.month_year = lms.month_year

ORDER BY c.month_year DESC