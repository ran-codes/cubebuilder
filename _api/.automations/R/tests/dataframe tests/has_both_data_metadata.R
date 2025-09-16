

has_both_data_metadata <- function(df_salurbal_source_input) {
  
  dataset_status <- df_salurbal_source_input %>%
    group_by(dataset_instance) %>%
    summarise(
      has_data = "data" %in% type,
      has_metadata = "metadata" %in% type,
      .groups = "drop"
    ) %>%
    mutate(is_complete = has_data & has_metadata)
  
  all_complete <- all(dataset_status$is_complete)
  
  if (!all_complete) {
    incomplete_datasets <- dataset_status %>%
      filter(!is_complete) %>%
      pull(dataset_instance)
    
    message <- str_c("The following datasets are missing either data or metadata: ",
                     str_c(incomplete_datasets, collapse = ", "))
    warning(message)
    return(FALSE)
  }
  
  return(TRUE)

  }