SELECT
  cast(store_id as string) as store_id, 
  store_name, 
  phone, 
  email, 
  street, 
  city, 
  state, 
  cast(zip_code as string) as zip_code
FROM {{source('local_bike','stores')}}