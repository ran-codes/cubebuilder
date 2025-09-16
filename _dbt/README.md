# SALURBAL-ETL DBT

This dbt project compiles cubes as well as other task (schema harmonizations, integration of cube-downstream information such as censorship) utilmiately into versioned cubes that can be used as data or metadata APIs for downstream applications. 

Key Links:

- [SALURBAL API Track Page](https://www.notion.so/drexel-ccuh/24f57008e8858146a230fd76f5491584?v=24f57008e885816390e7000c70fabebc&p=24f57008e88581efa4c3f0ccaa867ea8&pm=s&pvs=31)
- API Releases
    - [v1.1](https://www.notion.so/drexel-ccuh/SALURBAL-API-v1-1-24f57008e88581efa4c3f0ccaa867ea8)
    - [v1.2 - In Progress](notion.so/drexel-ccuh/SALURBAL-API-v1-1-25357008e8858048b1b7c6134ef309f9?v=24f57008e885816390e7000c70fabebc&pvs=25)

## Flow 

1. `.automations/salurbal-dbt-source-base-automation.qmd` - Source and Base SQL model automation from loaded cubes 
2. `DBT run --models base`
3. `salurbal-dbt-censorship.qmd` - Censorship information integration (in all v0 and v1 major releases censorship is tracked in CSV but this may change to Notion in v2 major releases). 
4. `dbt run -models int/final`
5. Export or use hooks to export production models into versioned endpoints

