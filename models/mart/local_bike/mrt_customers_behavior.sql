WITH
  rfm AS (
    SELECT
      customer_id,
      customer_name,
      customer_state,
      customer_city,
      MAX(order_date) AS last_purchase_date,
      MAX(order_id) AS last_order_id,      
      COUNT(DISTINCT order_id) AS nb_orders,
      ROUND(SUM(total_order_amount), 2) AS total_amount_spend,
      ROUND(SUM(total_order_amount) / COUNT(DISTINCT order_id), 2)
        AS avg_spend_per_order
    FROM {{ref('int_local_bike__orders')}}
    GROUP BY 
      customer_id,
      customer_name,
      customer_state,
      customer_city
  ),

  max_date AS (
    SELECT
      MAX(order_date) AS max_date
    FROM {{ref('int_local_bike__orders')}}
  ),

  rfm_score AS (
    SELECT
      customer_id,
      customer_name,
      customer_state,
      customer_city,
      total_amount_spend,
      NTILE(5) OVER (ORDER BY total_amount_spend) AS amount_spend_score,
      avg_spend_per_order,
      nb_orders,
      CASE
        WHEN nb_orders > 5 THEN 5
        WHEN nb_orders = 4 THEN 4
        WHEN nb_orders = 3 THEN 3
        WHEN nb_orders = 2 THEN 2
        WHEN nb_orders = 1 THEN 1
        ELSE 0
        END AS frequency_score,
      last_purchase_date,
      last_order_id,
      CASE
        WHEN last_purchase_date > DATE_SUB(md.max_date, INTERVAL 6 MONTH) THEN 5
        WHEN last_purchase_date > DATE_SUB(md.max_date, INTERVAL 12 MONTH)
          THEN 4
        WHEN last_purchase_date > DATE_SUB(md.max_date, INTERVAL 18 MONTH)
          THEN 3
        WHEN last_purchase_date > DATE_SUB(md.max_date, INTERVAL 24 MONTH)
          THEN 2
        ELSE 1
        END AS recency_score
    FROM rfm
    CROSS JOIN max_date md
    ORDER BY total_amount_spend DESC
  )
SELECT
  *,
  CASE
    WHEN amount_spend_score >= 4 AND frequency_score >= 3 AND recency_score >= 4
      THEN "Top_client"
    WHEN recency_score <= 2 THEN "Churn_risk"
    ELSE "Other_clients"
    END AS client_segments
FROM rfm_score

