
SELECT
  *
FROM {{ source('TMP_v2', 'tmp_v2__data') }}
{{ limit_data_in_dev() }}

