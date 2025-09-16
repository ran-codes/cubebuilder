
SELECT 
    var_name,
    CASE 
        WHEN CAST(keep AS FLOAT) = 1.0 THEN '1'
        ELSE '0'
    END AS dmc_keep_var
FROM '.automations/censorship/2024-09-09/variable_censorship_20240909.csv'
