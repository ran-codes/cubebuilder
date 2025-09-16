WITH precensor_admin_cube AS (
    SELECT *
    FROM {{ ref('int__precensored_admin_cube') }}
),

censor AS (
    SELECT
        var_name,
        dmc_keep_var
    FROM {{ ref('base__dmc_censorship') }}
),

merged AS (
    SELECT
        precensor_admin_cube.*,
        COALESCE(censor.dmc_keep_var, '9') as dmc_keep_var
    FROM precensor_admin_cube
    LEFT JOIN censor ON precensor_admin_cube.var_name = censor.var_name
) 

SELECT
    *, 
    CASE
        WHEN censor_obs_type = '1'         THEN '88_obs_type'
        WHEN censor_geo = '1'              THEN '88_geo'
        WHEN censor_time_resolution = '1'  THEN '88_time_resolution'
        WHEN censor_estimate_type = '1'    THEN '88_estimate_type'
        WHEN censor_most_recent_year = '1' THEN '88_not_recent_year'
        WHEN dmc_keep_var != '1' THEN '88_censor_dmc'
        ELSE public
    END AS on_portal, 
FROM merged 