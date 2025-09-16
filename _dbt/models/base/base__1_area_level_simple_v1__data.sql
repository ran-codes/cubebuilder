
SELECT
  *
FROM {{ source('1_area_level_simple_v1', '1_area_level_simple_v1__data') }}
{{ limit_data_in_dev() }}

