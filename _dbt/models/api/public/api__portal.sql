SELECT 
    *
FROM {{ ref('core__admin_cube') }}
WHERE on_portal = '1'
