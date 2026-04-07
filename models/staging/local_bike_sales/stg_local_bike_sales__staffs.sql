SELECT
  staff_id,
  concat(first_name,'_',last_name) as staff_name,
  email,
  phone,
  active,
  store_id,
  manager_id
FROM {{source('local_bike','staffs')}}