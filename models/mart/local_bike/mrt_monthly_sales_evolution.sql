WITH
  calendar AS (
    SELECT
      month_year
    FROM
      (
        SELECT
          DATE_TRUNC(MIN(order_date), MONTH) AS min_date,
          DATE_TRUNC(MAX(order_date), MONTH) AS max_date
        FROM {{ref('int_local_bike__orders')}}
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
    ROUND(SAFE_DIVIDE(SUM(total_order_amount), COUNT(DISTINCT order_id)),2) AS avg_order_value
    FROM {{ref('int_local_bike__orders')}}
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
  COALESCE(total_sales_amount,0)                                                                      as total_sales_amount,
  COALESCE(ROUND((SAFE_DIVIDE(total_sales_amount,precedent_month_total_sales_amount)-1)*100,1),0)     as evol_sales_amount_vs_precedent_month_in_percentage,  
  COALESCE(ROUND((SAFE_DIVIDE(total_sales_amount,lastyear_month_total_sales_amount)-1)*100,1),0)      as evol_sales_amount_vs_lastyear_in_percentage,
  COALESCE(total_sales_quantity,0)                                                                    as total_sales_quantity, 
  COALESCE(ROUND((SAFE_DIVIDE(total_sales_quantity,precedent_month_total_sales_quantity)-1)*100,1),0) as evol_sales_quantity_vs_precedent_month_in_percentage,  
  COALESCE(ROUND((SAFE_DIVIDE(total_sales_quantity,lastyear_month_total_sales_quantity)-1)*100,1),0)  as evol_sales_quantity_vs_lastyear_in_percentage,
  COALESCE(nb_orders,0)                                                                               as nb_orders,
  COALESCE(ROUND((SAFE_DIVIDE(total_sales_quantity,precedent_month_nb_orders)-1)*100,1),0)            as evol_nb_orders_vs_precedent_month_in_percentage,  
  COALESCE(ROUND((SAFE_DIVIDE(nb_orders,lastyear_month_nb_orders)-1)*100,1),0)                        as evol_nb_orders_vs_lastyear_in_percentage,
  COALESCE(avg_order_value,0)                                                                         as avg_order_value,
  COALESCE(ROUND((SAFE_DIVIDE(avg_order_value,precedent_month_avg_order_value)-1)*100,1),0)           as evol_avg_order_value_vs_precedent_month_in_percentage,  
  COALESCE(ROUND((SAFE_DIVIDE(avg_order_value,lastyear_month_avg_order_value)-1)*100,1),0)            as evol_avg_order_value_vs_lastyear_in_percentage
  
FROM calendar c
LEFT JOIN monthly_sales ms ON c.month_year = ms.month_year
LEFT JOIN precedent_monthly_sales pms ON c.month_year = pms.month_year
LEFT JOIN lastyear_monthly_sales lms ON c.month_year = lms.month_year

ORDER BY c.month_year DESC