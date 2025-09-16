
SELECT 
  *,
  dataset_version AS version
FROM 
  (
    select * from {{ref('base__1_area_level_simple_v1__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__2_record_level_simple_v1__metadata')}}
  )

