WITH data_cube AS (
    SELECT *
    FROM {{ ref('int__precensored_data_cube') }}
),

metadata_cube AS (
    SELECT * FROM {{ ref('int__precensored_metadata_cube') }}
),

merged AS (
    SELECT
        d.*,
        m.* EXCLUDE (
            dataset_id, var_name, iso2, strata_id, geo, year,
            schema_version, version, dataset_version,
            dataset_instance, observation_type, month, day
        )
    FROM data_cube d
    LEFT JOIN metadata_cube m
        ON d.dataset_id = m.dataset_id
        AND d.var_name = m.var_name
        AND d.iso2 = m.iso2
        AND d.strata_id = m.strata_id
        AND d.geo = m.geo
        AND d.year = m.year
        AND d.schema_version = m.schema_version
        AND d.version = m.version
        AND d.dataset_version = m.dataset_version
        AND d.dataset_instance = m.dataset_instance
        AND d.observation_type = m.observation_type
        AND d.month = m.month
        AND d.day = m.day
),

intermediate AS (
    SELECT
    merged.*,
    CASE
        WHEN day != '' THEN 'day'
        WHEN month != '' AND day = '' THEN 'month'
        WHEN year LIKE '%-%' AND month = '' AND day = '' THEN 'year range'
        WHEN year NOT LIKE '%-%' AND month = '' AND day = '' THEN 'year'
        ELSE NULL
    END AS time_resolution_type,
    CASE
        WHEN value_iteration IS NULL OR value_iteration = '' OR value_iteration = ' '  THEN 'estimate' 
        ELSE 'iteration'
    END AS estimate_type
    FROM merged
),

hotfixes AS (
    SELECT
        intermediate.* EXCLUDE (strata_description),
        regexp_replace(strata_description, '^NA$', '') AS strata_description,
    FROM intermediate
)

SELECT 
    *,
    IF (observation_type NOT IN ('area-level'), '1', '0') as censor_obs_type,
    IF (geo NOT IN ('L1AD'), '1', '0') as censor_geo,
    IF (time_resolution_type NOT IN ('year', 'year range'), '1', '0') as censor_time_resolution,
    IF (estimate_type  NOT IN ('estimate'), '1', '0') as censor_estimate_type,
    CASE
        WHEN censor_obs_type = '1'         THEN '88_obs_type'
        WHEN censor_geo = '1'              THEN '88_geo'
        WHEN censor_time_resolution = '1'  THEN '88_time_resolution'
        WHEN censor_estimate_type = '1'    THEN '88_estimate_type'
        WHEN censor_most_recent_year = '1' THEN '88_not_recent_year'
        ELSE public
    END AS public__pre_dmc_censor
FROM hotfixes
