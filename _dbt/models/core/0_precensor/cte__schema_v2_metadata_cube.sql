
SELECT 
  *,
  dataset_version AS version
FROM 
  (
    select * from {{ref('base__aplozone_v1__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__apm_daily_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__aps_v3.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__aps_daily_v1__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__bec_v2.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__bec_restricted_v2.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__enso_v1__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__healthsurvey_adult_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__healthsurvey_child_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__lemedian_l1_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__le_l1_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__prj_v2.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__sec_segregationidx_v1.0__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__tmp_v2__metadata')}}
  UNION ALL BY NAME 
select * from {{ref('base__tmpdaily_v2.0__metadata')}}
  )

