
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

hotfixes AS (
    SELECT
        merged.* EXCLUDE (strata_description),
        regexp_replace(strata_description, '^NA$', '') AS strata_description,
    FROM merged
)

SELECT *
FROM hotfixes
