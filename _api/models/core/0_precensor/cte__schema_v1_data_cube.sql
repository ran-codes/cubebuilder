SELECT 
   * ,
   '' AS value_iteration
FROM read_parquet('//files.drexel.edu/colleges/SOPH/Shared/UHC/Projects/Wellcome_Trust/Data Methods Core/Dashboards/dbt/salurbal-dbt-server/sources/_seeds/data_v1.parquet')
{{ limit_data_in_dev() }}