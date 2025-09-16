SELECT
    *
FROM {{ ref('int__precensored_admin_cube') }}

-- Previous censorship logic (for reference, can be applied post-API as needed):
-- CASE
--     WHEN censor_obs_type = '1'         THEN '88_obs_type'
--     WHEN censor_geo = '1'              THEN '88_geo'
--     WHEN censor_time_resolution = '1'  THEN '88_time_resolution'
--     WHEN censor_estimate_type = '1'    THEN '88_estimate_type'
--     WHEN censor_most_recent_year = '1' THEN '88_not_recent_year'
--     WHEN dmc_keep_var != '1' THEN '88_censor_dmc'
--     ELSE public
-- END AS on_portal