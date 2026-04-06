SELECT
  cast(staff_id as string) as staff_id,
  first_name,
  last_name,
  email,
  phone,
  cast(active as string) as active,
  cast(store_id as string) as store_id,
  manager_id
FROM {{source('local_bike','staffs')}}