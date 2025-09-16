#'   Example:
#'     row = context$df_salurbal_source_input %>% slice(1)

write_dbt_base_model = function(row, context){
  
base_model_template_sql <-  "
SELECT
  *
FROM {{ source('{{ dataset_instance }}', '{{ source_model_id }}') }}
{{ limit_data_in_dev }}
"
  
  {# Setup -------------------------------------------------------------------
    dataset_instance = row$dataset_instance 
    model_id = row$base_model_id
    path = row$path
    type = row$path
    base_model_sql_name = glue("{model_id}.sql")
    base_model_yml_name = glue("{model_id}.yml")
    sql_endpoint = glue("../models/base/{base_model_sql_name}")
    yml_endpoint = glue("../models/base/{base_model_yml_name}")
    cli_alert("Start base__model.sql for {model_id}")

  }

  { # Generate .sql -------------------------------------------------------------
    base_model_template_sql <- gsub("\\{\\{\\s*dataset_instance\\s*\\}\\}",dataset_instance, base_model_template_sql)
    base_model_template_sql <- gsub("\\{\\{\\s*source_model_id\\s*\\}\\}",row$source_model_id, base_model_template_sql)
    base_model_template_sql <- gsub("\\{\\{\\s*limit_data_in_dev\\s*\\}\\}",
                                    ifelse(row$type=='data','{{ limit_data_in_dev() }}',''), 
                                    base_model_template_sql)
  }

  {# Write .sql --------------------------------------------------------------
    write(base_model_template_sql, file = sql_endpoint)
    cli_alert_success("{base_model_sql_name} written")        
  }
  
 
  
 
  
}
