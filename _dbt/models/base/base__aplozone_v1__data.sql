
SELECT
  *
FROM {{ source('APLOZONE_v1', 'aplozone_v1__data') }}
{{ limit_data_in_dev() }}

