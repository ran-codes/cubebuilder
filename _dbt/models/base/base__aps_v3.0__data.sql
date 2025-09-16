
SELECT
  *
FROM {{ source('APS_v3.0', 'aps_v3.0__data') }}
{{ limit_data_in_dev() }}

