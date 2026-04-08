
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
), 

deliveries as (
    select 
        DATE_TRUNC(order_date, MONTH) AS month_year,
        store_id,
        SUM(cast(order_not_delivered as INT64)) as nb_order_not_delivered,
        SUM(cast(shipment_is_late as INT64)) as nb_shipments_late
    from {{ref('mrt_orders_management')}}  
    group by 1,2),

store_stocks as (
    SELECT
        store_id,
        SUM(stock_to_date) as stock_to_date
    FROM {{ref('int_local_bike__stocks')}} 
    GROUP BY 1)


SELECT
    s.month_year,
    s.store_id,
    s.store_name,
    s.store_city,
    s.store_state,
    ROUND(s.total_turnover, 2) AS total_turnover,
    ROUND(s.total_turnover / SUM(s.total_turnover) OVER (PARTITION BY s.month_year) * 100, 2) AS turnover_contribution,
    ROW_NUMBER() OVER ( PARTITION BY s.month_year ORDER BY s.total_turnover DESC) AS ranking_turnover_stores_per_month,
    s.total_sales_quantity,
    s.nb_orders,
    s.avg_amount_per_order,
    d.nb_order_not_delivered,
    d.nb_shipments_late,
    st.stock_to_date
FROM sales s 
LEFT JOIN deliveries d 
ON s.month_year = d.month_year and s.store_id = d.store_id
LEFT JOIN store_stocks st
ON s.store_id = st.store_id
ORDER BY month_year DESC, ranking_turnover_stores_per_month