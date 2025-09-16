
SELECT
  *
FROM {{ source('BEC_v2.0', 'bec_v2.0__data') }}
{{ limit_data_in_dev() }}

