(SELECT * FROM {{ ref('cte__schema_v2_data_cube')}})
UNION ALL BY NAME
(SELECT * FROM {{ ref('cte__schema_v1_data_cube')}} schema_v1
 ANTI JOIN {{ ref('cte__schema_v2_data_cube')}} v2 USING (dataset_instance))