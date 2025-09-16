{ # 0. Setup --------------------------------------------------
  context = get_context()
}

{ # 1. Pre-DBT ETL --------------------------------------------------
  
  { ## 1.1 Source YAML (Done) --------------------------------------------------
    context$df_salurbal_source_input %>%
      group_by(row_number()) %>% 
      group_walk(~generate_source_yml(.x, context))
  }
  
  { # 1.2 Base Models (Done) ----------------------------------------------------
    context$df_salurbal_source_input %>% 
      group_by(row_number()) %>% 
      group_walk(~write_dbt_base_model(.x, context))
  }
    
  { # 1.3 Intermediate Models ----------------------------------------------------
    context$df_salurbal_int_input %>% 
      group_by(row_number()) %>% 
      group_walk(~write_dbt_int_model(.x, context))
  }

  
  { # 1.4 Central Models ----------------------------------------------------
    write_dbt_central_core_model(context)
  }

}
