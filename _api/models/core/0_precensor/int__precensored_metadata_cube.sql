WITH metadata_v2 AS (
  SELECT
    {{ dbt_utils.star(
      from=ref('cte__schema_v2_metadata_cube'),
      except=['list_subdomain', 'estimate_type', 'time_resolution_type', 
              'staged_int_metadata','has_confidence_interval','file_data',
              'var_name_raw','value_iteration']
    ) }}
  FROM {{ ref('cte__schema_v2_metadata_cube')}}
),

metadata_v1 AS (
    SELECT 
    {{ dbt_utils.star(
      from=ref('cte__schema_v1_metadata_cube'),
      except=['list_subdomain', 'estimate_type', 'time_resolution_type', 
              'staged_int_metadata','has_confidence_interval','file_data',
              'var_name_raw','value_iteration']
    ) }}
  FROM {{ ref('cte__schema_v1_metadata_cube')}}
  WHERE dataset_instance NOT IN (
    SELECT DISTINCT dataset_instance
    FROM {{ ref('cte__schema_v2_metadata_cube')}}
  )
),

metadata as (
  SELECT * FROM metadata_v1
  UNION ALL BY NAME
  SELECT * FROM metadata_v2
),

year_clean_data AS (
  SELECT
    *,
    CAST(SUBSTRING(year, 1, 4) AS INTEGER) AS year_clean
  FROM metadata
),

most_recent_years AS (
  SELECT
    dataset_instance,
    var_name,
    iso2,
    MAX(year_clean) AS most_recent_year
  FROM year_clean_data
  GROUP BY dataset_instance, var_name, iso2
),

flagged_metadata AS (
  SELECT
    ycd.*,
    mry.most_recent_year,
    CASE 
      WHEN ycd.year_clean = mry.most_recent_year THEN '0'
      ELSE '1'
    END AS censor_most_recent_year
  FROM year_clean_data ycd
  LEFT JOIN most_recent_years mry
    ON ycd.dataset_instance = mry.dataset_instance
    AND ycd.var_name = mry.var_name
    AND ycd.iso2 = mry.iso2
)

SELECT * FROM flagged_metadata

