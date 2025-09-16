#'   Example:
#'       row = context$df_salurbal_int_input %>% slice(1)

write_dbt_precore_model = function(row, context){
  
template <-  "
{% set expected_columns = [
  'dataset_id', 'file_data', 'var_name', 'var_name_raw', 'iso2', 'strata_id',
  'geo', 'salid', 'year', 'value', 'dataset_notes', 'strata_description',
  'file_codebook', 'source', 'public', 'acknowledgements', 'domain', 'subdomain',
  'var_label', 'var_def', 'value_type', 'units', 'coding', 'limitations',
  'longitudinal', 'variable_origin', 'staged_int_metadata', 'day', 'month',
  'value_iteration', 'dataset_instance', 'has_confidence_interval', 'estimate_type',
  'time_resolution_type', 'value_uci', 'value_lci', 'version', 'source_URL',
  'source_terms_of_use_URL'
] %}
{% set int__table = ref('{{ int__data_model_key }}') %}
{% set int__table_columns = dbt_utils.star(from=int__table) %}

select
    {% for expected_column in expected_columns %}
        {% if expected_column in int__table_columns %}
            {{ expected_column }}
        {% else %}
            '' as {{ expected_column }}
        {% endif %} 
        {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ int__table }}
"
  
  {# Setup -------------------------------------------------------------------
    model_id = row$precore_model_id
    sql_endpoint = glue("../models/precore/{model_id}.sql")
    yml_endpoint = glue("../models/precore/{model_id}.yml")
    cli_alert("Start generating - {model_id}")
  }

  { # Generate .sql -------------------------------------------------------------
    template <- gsub("\\{\\{\\s*int__data_model_key\\s*\\}\\}",row$int_model_id, template)
  }

  {# Write .sql --------------------------------------------------------------
    write(template, file = sql_endpoint)
    cli_alert_success("{model_id} written")        
  }
  
 
  
 
  
}
