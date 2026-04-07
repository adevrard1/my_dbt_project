WITH 
product_sales as (
SELECT 
  product_id,
  DATE_TRUNC(order_date,MONTH) as month_year,
  order_date as date,
  ROUND(sum(order_item_amount),2) as total_amount,
  sum(order_item_quantity) as total_quantity 

 FROM {{ref('stg_local_bike_sales__order_items')}} oi 
 LEFT JOIN {{ref('stg_local_bike_sales__orders')}} o 
 ON oi.order_id = o.order_id

GROUP BY 1,2,3), 

product_description as (
  SELECT 
    product_id,
    product_name,
    brand_name,
    category_name,
    model_year,
    start_price
  FROM {{ref('stg_local_bike_production__products')}} p 
  LEFT JOIN {{ ref('stg_local_bike_production__categories') }} c 
    ON p.category_id = c.category_id
  LEFT JOIN {{ ref('stg_local_bike_production__brands') }} b
    ON p.brand_id = b.brand_id 
),

product_stock as (
  SELECT
    product_id,
    SUM(stock_to_date) as stock_to_date
  FROM {{ref('stg_local_bike_production__stocks')}}
  GROUP BY product_id
)

select 
  date,
  month_year,
  pd.product_id,
  product_name,
  brand_name,
  category_name,
  model_year,
  start_price,
  ROUND(total_amount,2) as total_amount,
  total_quantity,
  ROUND(total_amount/total_quantity,2) as final_price,
  ROUND(total_amount/total_quantity - start_price,2) as price_gap_after_discount,
  stock_to_date

FROM product_description pd 
LEFT JOIN product_sales ps 
ON pd.product_id = ps.product_id
LEFT JOIN product_stock pst
ON pd.product_id = pst.product_id