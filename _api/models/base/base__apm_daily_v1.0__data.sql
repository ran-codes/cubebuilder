
SELECT
  *
FROM {{ source('APM_DAILY_v1.0', 'apm_daily_v1.0__data') }}
{{ limit_data_in_dev() }}

