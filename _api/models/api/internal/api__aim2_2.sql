SELECT *
FROM {{ ref('core__admin_cube') }}
WHERE 
    public = '1' AND 
    estimate_type = 'estimate' AND
    dmc_keep_var = '1' AND
    observation_type = 'area-level'