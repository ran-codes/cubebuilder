SELECT 
  public,
  public__pre_dmc_censor,
  dmc_keep_var,
  on_portal
FROM {{ ref('core__admin_cube') }}
WHERE
  (dmc_keep_var != '1' AND on_portal = '1')
  OR (public__pre_dmc_censor != '1' AND on_portal = '1') 
  OR (public != '1' AND on_portal = '1')