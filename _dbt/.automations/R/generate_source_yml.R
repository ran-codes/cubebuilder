 
# row = context$df_salurbal_source_input  %>% slice(1)
# row = context$df_salurbal_source_input  %>% slice(1)
# row = context$df_salurbal_source_input %>% filter(type == 'data') %>% slice(1)
# row = context$df_salurbal_source_input %>% filter(type == 'metadata') %>% slice(1)

generate_source_yml <- function(row) {
  
  { # Setup -------------------------------------------------------------------
    model_id = row$source_model_id
    src_endpoint = glue("../models/sources/{model_id}.yml")
    cli_alert("Start source.yml generation for - {model_id}")
  }
  
  { # Column Metadata ---------------------------------------------------------
    #  QUARENTINE for future development.
    # df_columns_tmp = context$df_columns__data
    # if (row$type == 'metadata') df_columns_tmp = context$df_columns__metadata
    # column_metadata = df_columns_tmp %>% 
    #   group_by(row_number()) %>%
    #   group_map( ~ {
    #     column = list(
    #       name = .x$field,
    #       type = .x$type,
    #       description = .x$description,
    #       meta = list(coding =  .x$coding)
    #     )
    #     return(column)
    #   })
  }
  
  { # source.yml --------------------------------------------------------------
    source_yml <- list(version = as.integer(2),
                       sources = list(
                         list(
                           name = row$dataset_instance,
                           tags = c(glue('DBT Source {row$type}'), row$dataset_instance),
                           meta = list(external_location = row$path),
                           tables = list(
                             list(
                               name = model_id,
                               description =  ifelse(
                                 row$type == 'data',
                                 glue('This is the data OBT for {row$dataset_instance}'),
                                 glue('This is the metadata OBT for {row$dataset_instance}')
                               )#,
                               # columns = column_metadata
                               )   )  )   ))
  }
  
  
  { # Write -------------------------------------------------------------------
    write_yaml(source_yml, src_endpoint)
    cli_alert_success("Write source.yml for {model_id}")
  }
  
}
