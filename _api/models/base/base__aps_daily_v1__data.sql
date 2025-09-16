
SELECT
  *
FROM {{ source('APS_DAILY_v1', 'aps_daily_v1__data') }}
{{ limit_data_in_dev() }}

