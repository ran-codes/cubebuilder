
SELECT
  *
FROM {{ source('TMPDAILY_v2.0', 'tmpdaily_v2.0__data') }}
{{ limit_data_in_dev() }}

