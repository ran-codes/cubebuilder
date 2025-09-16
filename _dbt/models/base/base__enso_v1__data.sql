
SELECT
  *
FROM {{ source('ENSO_v1', 'enso_v1__data') }}
{{ limit_data_in_dev() }}

