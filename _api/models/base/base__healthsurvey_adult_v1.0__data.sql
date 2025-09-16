
SELECT
  *
FROM {{ source('HealthSurvey_ADULT_v1.0', 'healthsurvey_adult_v1.0__data') }}
{{ limit_data_in_dev() }}

