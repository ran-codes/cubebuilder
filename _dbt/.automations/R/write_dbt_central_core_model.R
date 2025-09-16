
write_dbt_central_core_model = function(context){


sql_template <-  "
{{ int_models }}
"
  
  {# Setup -------------------------------------------------------------------
    int_models = context$df_salurbal_int_input %>% pull(int_model_id)
    out_model = 'core__area_level'
    sql_endpoint = glue("../models/core/{out_model}.sql") 
    cli_alert("Start {out_model} generation.")
  }

  { # Generate .sql -------------------------------------------------------------
    sql_template <- gsub("\\{\\{\\s*int_models\\s*\\}\\}", 
                         glue("select * from {{{{ref('{int_models}')}}}}") %>% 
                           paste(collapse = "\n  union all \n"), 
                         sql_template)
  }
  
  {# Write .sql --------------------------------------------------------------
    write(sql_template, file = sql_endpoint)
    cli_alert_success("{out_model}.sql written")        
  }
  
}
