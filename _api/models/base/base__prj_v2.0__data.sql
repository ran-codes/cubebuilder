
SELECT
  *
FROM {{ source('PRJ_v2.0', 'prj_v2.0__data') }}
{{ limit_data_in_dev() }}

