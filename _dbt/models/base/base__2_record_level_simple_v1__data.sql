
SELECT
  *
FROM {{ source('2_record_level_simple_v1', '2_record_level_simple_v1__data') }}
{{ limit_data_in_dev() }}

