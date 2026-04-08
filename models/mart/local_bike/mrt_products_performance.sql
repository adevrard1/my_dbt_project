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
)

SELECT
    month_year,
    product_id,
    product_name,
    brand_name,
    category_name,
    model_year,
    total_amount AS turnover,
    ROUND(SAFE_DIVIDE(total_amount, SUM(total_amount) OVER (PARTITION BY month_year)) * 100,1) AS turnover_contribution,
    ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY total_amount DESC) AS ranking_products_by_turnover_per_month,
    total_quantity,
    avg_price,
    start_price,
    price_discount,
    stock_to_date,
    CASE 
        WHEN stock_to_date = 0 THEN 'out of stock'
        WHEN stock_to_date < 10 THEN 'low stock'
        ELSE 'enough stock'
    END AS stock_management
FROM monthly_sales_per_product 
ORDER BY month_year desc, turnover desc