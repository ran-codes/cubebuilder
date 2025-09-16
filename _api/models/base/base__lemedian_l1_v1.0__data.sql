
SELECT
  *
FROM {{ source('LEMEDIAN_L1_v1.0', 'lemedian_l1_v1.0__data') }}
{{ limit_data_in_dev() }}

