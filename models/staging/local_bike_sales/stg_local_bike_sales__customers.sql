SELECT
  customer_id,
  concat(first_name,'_',last_name) as customer_name,
  phone,
  email,
  street,
  city as customer_city,
  state as customer_state,
  zip_code
FROM {{source('local_bike','customers')}}