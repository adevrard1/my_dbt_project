{% docs mrt_customers_behavior %}

This table aims to analyze customer behavior by tracking key metrics such as:
- total_amount_spend
- avg_spend_per_order  
- nb_orders  
- last_purchase_date

 It also includes an RFM(recency,frequency, monetary) scores to segment customers based on their value : 
 - amount_spend_score : The amount spend score is assigned using quintiles (NTILE(5)) based on total amount spent: lowest values receive score 1 and highest values receive score 5.
 - frequency_score :  If the number of orders is greater than 5: score 5; equal to 4: score 4; equal to 3: score 3; equal to 2: score 2; equal to 1: score 1; otherwise: score 0.
 - recency_score : If the last purchase occurred less than 6 months ago: score 5; less than 12 months: score 4; less than 18 months: score 3; less than 24 months: score 2; more than 24 months: score 1.
The highest the score is the better it is. Scores can not exceed 5. 

 It helps identifying in the **client_segments** : loyal customers with high potential and inactive customers at risk of churn.

{% enddocs %}

