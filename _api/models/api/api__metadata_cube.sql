WITH excluded_data_attributes AS (
  SELECT * EXCLUDE (
    observation_id,
    salid,
    value,
    value_iteration,
    var_name_raw,
    value_uci,
    value_lci
  )
  FROM {{ ref('core__admin_cube') }}
)

SELECT  
    *,
    count(*) AS n_data_points
  FROM  excluded_data_attributes
  GROUP BY *