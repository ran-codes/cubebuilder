
SELECT
  *
FROM {{ source('BEC_RESTRICTED_v2.0', 'bec_restricted_v2.0__data') }}
{{ limit_data_in_dev() }}

