write_dbt_int_model <- function(row, context) {
  int_model_template_sql <- "
-- Define project wide standardized OBT columns
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

-- Get Available columns in current OBT
{% set data_table = ref('{{base__data_model}}') %}
{% set metadata_table = ref('{{base__metadata_model}}') %}
{% set data_columns = dbt_utils.star(from=data_table) %}
{% set metadata_columns = dbt_utils.star(from=metadata_table) %}
{% set data_column_list = data_columns.split(',') | map('trim') | map('replace', '\"', '') | list %}
{% set metadata_column_list = metadata_columns.split(',') | map('trim') | map('replace', '\"', '') | list %}
{% set available_columns = data_column_list + metadata_column_list | unique | sort %}

-- Main Query
with data as (
    select {{ dbtplyr.not_one_of(['public'], ref('{{base__data_model}}')) | join(', ') }}
    from {{ ref('{{base__data_model}}') }}
),

metadata as (
    select {{ dbtplyr.not_one_of(['n_salid_data_points'], ref('{{base__metadata_model}}')) | join(', ') }}
    from {{ ref('{{base__metadata_model}}') }}
),

merged as (
    select
    data.*,
    metadata.*
    from data
    left join metadata
        on data.dataset_id = metadata.dataset_id
        and data.var_name = metadata.var_name
        and data.var_name_raw = metadata.var_name_raw
        and data.iso2 = metadata.iso2
        and data.strata_id = metadata.strata_id
        and data.geo = metadata.geo
        and data.year = metadata.year
)

select
    {% for expected_column in expected_columns %}
        {% if expected_column in available_columns %}
            {{ expected_column }}
        {% else %}
            '' as {{ expected_column }}
        {% endif %}
        {% if not loop.last %},{% endif %}
    {% endfor %}
from 
    merged
"

# Setup
model_id <- row$int_model_id
sql_endpoint <- glue::glue("../models/int/{model_id}.sql")
yml_endpoint <- glue::glue("../models/int/{model_id}.yml")
cli::cli_alert("Start generating - {model_id}")

# Generate .sql
int_model_template_sql <- gsub("\\{\\{\\s*base__metadata_model\\s*\\}\\}", row$metadata, int_model_template_sql)
int_model_template_sql <- gsub("\\{\\{\\s*base__data_model\\s*\\}\\}", row$data, int_model_template_sql)

# Write .sql
writeLines(int_model_template_sql, con = sql_endpoint)
cli::cli_alert_success("{model_id} written")
 
}