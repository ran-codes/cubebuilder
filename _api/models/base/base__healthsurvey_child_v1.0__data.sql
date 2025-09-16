
SELECT
  *
FROM {{ source('HealthSurvey_CHILD_v1.0', 'healthsurvey_child_v1.0__data') }}
{{ limit_data_in_dev() }}

