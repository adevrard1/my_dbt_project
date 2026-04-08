SELECT
  store_id, 
  store_name, 
  phone, 
  email, 
  street, 
  city as store_city,
  state as store_state,
  zip_code
FROM {{source('local_bike','stores')}}