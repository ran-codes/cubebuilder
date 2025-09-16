#' Generate global context object for 

get_context <- function(){
  

  # Paths ------------------------------------------------------------
  paths = lst(
    dmc_path = '//files.drexel.edu/colleges/SOPH/Shared/UHC/Projects/Wellcome_Trust/Data Methods Core/',
    dmc_etl_path = paste0(dmc_path, 'Dashboards/ETL/'),
    dmc_etl_cache_path = paste0(dmc_etl_path, 'cache/'),
    root_path = paste0(dmc_path, 'Dashboards/FAIR Renovations/'),
    spatial_path = paste0(root_path,"_spatial/"),
    arcgispro_path = paste0(dmc_path,'ArcGISPro/SALURBAL_L1UX/'),
    salurbal_gdb_path = paste0(dmc_path,'Geodatabases/SALURBAL/'),
    crosswalk_path =  paste0(root_path,"_crosswalks/"),
    adm1_path = paste0(spatial_path,'adm1_boundaries.parquet'),
    adm1_5pct_path = paste0(spatial_path,'adm1_boundaries_5pct.parquet'),
    l1ad_path = paste0(spatial_path,'l1ad_boundaries.parquet'),
    l1ad_5pct_path = paste0(spatial_path,'l1ad_boundaries_5pct.parquet'),
    l1ad_centroids_path = paste0(spatial_path,'l1ad_centroids.parquet'),
    l1ad_centroids_df_path = paste0(spatial_path,'l1ad_centroids_dataframe.parquet'),
    l1ux_path = paste0(spatial_path,'l1ux_boundaries.parquet'),
    l1ux_5pct_path = paste0(spatial_path,'l1ux_boundaries_5pct.parquet'),
    l2_path = paste0(spatial_path,'l2_boundaries.parquet'),
    l2_5pct_path = paste0(spatial_path,'l2_boundaries_5pct.parquet'),
    l3_path = paste0(spatial_path,'l3_boundaries.parquet'),
    l3_5pct_path = paste0(spatial_path,'l3_boundaries_5pct.parquet'),
    dbt_path = '//files.drexel.edu/colleges/SOPH/Shared/UHC/Projects/Wellcome_Trust/Data Methods Core/Dashboards/dbt/server-salurbal-dbt-v1.0',
    dbt_metadata_path = glue("{dbt_path}/sources/metadata"),
    dbt_source_path = glue('{dbt_path}/sources'),
    dbt_prod_metadata = glue("{dbt_source_path}/metadata"),
    dbt_prod_metadata_denorm = glue("{dbt_source_path}/metadata_denorm"),
    dbt_prod_data_internal = glue("{dbt_source_path}/data_internal"),
    dbt_data_stage = glue('{dbt_path}/stage'),
    dbt_models_dev = file.path(dbt_path,'models-dev'),
    repo_clean = 'clean/marts/v1.0',
    repo_inventory = 'clean/inventory',
    repo_2_processed = 'clean/2-processed',
    repo_processed = 'code/marts/v1.0/processed',
    repo_local_api_dir = "clean/marts/v1.0/azure",
    portal_mart = '../SALURBAL Dashboard Portal/data-portal/salurbal-data-portal/app/datastore/',
  )
  
  
  # Crosswalks --------------------------------------------------------------
  crosswalks = list(
    xwalk_iso2 = read_parquet(paste0(paths$root_path,"_crosswalks/xwalk_iso2.parquet")),
    xwalk_l1ad = read_parquet(paste0(paths$root_path,"_crosswalks/xwalk_l1ad.parquet")),
    xwalk_l2 = read_parquet(paste0(paths$root_path,"_crosswalks/xwalk_l2.parquet"))
  )  
  
  
  # Cube setup  ---------------------------------------------------------------------
  {

    df_dataset_instances = tibble(metadata_denorm_path = list.files(paths$dbt_prod_metadata_denorm,
                                                                    full.names = T)) %>%
      mutate(
        metadata_denorm_file = basename(metadata_denorm_path),
        dataset_instance =  metadata_denorm_file %>% str_remove_all('_metadata.parquet'),
        dataset_id = str_sub(dataset_instance, 1L,-6L),
        version_str = str_sub(dataset_instance,-4L,-1L) ,
        version = str_sub(dataset_instance,-3L,-1L) %>% parse_number(),
        internal_data_denorm_path = glue(
          '{paths$dbt_prod_data_internal}/{dataset_instance}_internal.parquet'
        ),
        strata_csv_path = glue('datasets/{dataset_id}/{version_str}/2-strata.csv')
      ) %>%
      group_by(dataset_id) %>%
      filter(version == max(version)) %>%
      ungroup() %>%
      select(dataset_instance, everything()) #%>%
     # left_join(xwalk_metadata_by_var_strata)
    
    
    df_salurbal_source_input = df_dataset_instances %>% 
      select(dataset_instance, metadata_denorm_path, internal_data_denorm_path) %>% 
      pivot_longer(cols = c(metadata_denorm_path, internal_data_denorm_path), names_to = "type", values_to = "path") %>% 
      mutate(type = str_remove_all(type, "_denorm_path|internal_"),
             source_model_id = glue('{dataset_instance}__{type}') %>% str_to_lower(),
             base_model_id = glue("base__{dataset_instance}__{type}") %>% str_to_lower(),
             int_model_id = glue("int__{dataset_instance}") %>% str_to_lower(),
             precore_model_id = glue("precore__{dataset_instance}") %>% str_to_lower()
      ) %>%
      verify(has_both_data_metadata(.))
    
  
      
    df_int_columns = tibble(
      int_model_id = list.files(
        paths$dbt_models_dev, 
        pattern = 'int__',
        full.names = T)
    ) %>% 
      rowwise() %>% 
      mutate(columns = open_dataset(int_model_id) %>% names() %>% list()) %>% 
      ungroup() %>% 
      mutate(int_model_id = basename(int_model_id) %>% str_remove('.parquet')) %>% 
      select(int_model_id, columns)
    
    df_salurbal_int_input = df_salurbal_source_input %>% 
      select(int_model_id, precore_model_id, type, base_model_id) %>% 
      pivot_wider(names_from = type, values_from = base_model_id) %>% 
      left_join(df_int_columns)
      
    cube = lst(
      df_prod_dataset_instance = df_dataset_instances,
      df_salurbal_source_input = df_salurbal_source_input,
      df_salurbal_int_input = df_salurbal_int_input,
      vec__prod_dataset_instances = df_dataset_instances$dataset_instance,
      vec__accepted_geo = c("L1AD"),
      vec__accepted_time_res_types = c("year","year range"),
      vec__accepted_estimate_type = c("estimate"),
    )
    
  }
  

  ## Transaction table fields
  {
    

    
    df_columns__metadata = read_excel(
      path = "../../_seeds/templates/_template_details.xlsx",
      sheet = '4-codebook.csv' ) %>% 
      mutate(type = 'character')
    
    df_columns__data = read_excel(
      path = "../../_seeds/templates/_template_details.xlsx",
      sheet = '5-data.csv' ) %>% 
      mutate(type = 'character')
    
    ## Final polish to-do:
    # operationalize columns for composite keys
    # operationalize columns for data attributes
    # operationalize columns for optional metadta fields (source_URL)
    
    
    transactional_columns = lst(
      df_columns__metadata = df_columns__metadata,
      df_columns__data = df_columns__data
    )
  }
  
  # Final  ---------------------------------------------------------------------
  final = c(
    paths,
    crosswalks,
    cube,
    transactional_columns
  )
  
  cli_alert_success("Workbench Context Updated")
  return(final)
}

