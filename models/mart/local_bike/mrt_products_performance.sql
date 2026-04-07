WITH monthly_sales_per_product AS (
    SELECT 
        month_year,
        product_id,
        product_name,
        brand_name,
        category_name,
        model_year,
        start_price,
        ROUND(SUM(total_amount),2) AS total_amount,
        SUM(total_quantity) AS total_quantity,
        ROUND(SUM(total_amount)/NULLIF(SUM(total_quantity),0),2) AS avg_price,
        ROUND(SUM(total_amount)/NULLIF(SUM(total_quantity),0) - start_price,2) AS price_discount,
        SUM(stock_to_date) AS stock_to_date
    FROM {{ ref('int_local_bike__products') }} p 
    GROUP BY month_year, product_id, product_name, brand_name, category_name, model_year, start_price
),

max_date AS (
    SELECT MAX(date) AS max_date
    FROM {{ ref('int_local_bike__products') }}
),

last_30d_sales_per_product AS (
    SELECT 
        p.product_id,
        SUM(p.total_quantity)/30 AS avg_quantity_sold_per_day_last30d
    FROM {{ ref('int_local_bike__products') }} p
    JOIN max_date md
      ON p.date >= md.max_date - INTERVAL '30' DAY
    GROUP BY p.product_id
)

SELECT
    ms.month_year,
    ms.product_id,
    ms.product_name,
    ms.brand_name,
    ms.category_name,
    ms.model_year,
    ms.start_price,
    ms.total_amount AS turnover,
    ms.total_amount / SUM(ms.total_amount) OVER (PARTITION BY ms.month_year) * 100 AS turnover_contribution,
    ROW_NUMBER() OVER (PARTITION BY ms.month_year ORDER BY ms.total_amount DESC) AS ranking_products_by_turnover_per_month,
    ms.total_quantity,
    ms.avg_price,
    ms.price_discount,
    ms.stock_to_date,
    ms.stock_to_date / NULLIF(p.avg_quantity_sold_per_day_last30d,0) AS estimated_nb_days_of_stock_ahead,
    CASE 
        WHEN ms.stock_to_date <= 0 AND p.avg_quantity_sold_per_day_last30d > 0 THEN 'out of stock'
        WHEN ms.stock_to_date > 0 AND ms.stock_to_date / NULLIF(p.avg_quantity_sold_per_day_last30d,0) < 7 THEN 'not enough stock'
        WHEN ms.stock_to_date / NULLIF(p.avg_quantity_sold_per_day_last30d,0) > 30 THEN 'over stock'
        ELSE 'enough stock'
    END AS stock_management
FROM monthly_sales_per_product ms
LEFT JOIN last_30d_sales_per_product p 
  ON ms.product_id = p.product_id