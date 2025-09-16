# HCUP Extraction Loading

This repo contains codebase for extraction raw HCUP data via HCUP load scripts then loading them as parquet onto our UHC server. This is the **EL** part of our ELT pipeline. The **T**ransformation is organized in a data warehouse repository found at the [hcup-dbt repo](https://github.com/Drexel-UHC/hcup-dbt).

Please visit this [repository's GitHub page](https://drexel-uhc.github.io/hcup-extraction-loading/) for additional details.

Other useful links include:

- [DBT datawarehouse repo for HCUP project](https://github.com/Drexel-UHC/hcup-dbt)
- [Grammer of data manipulation (R/Python) cheatsheet](https://github.com/ran-codes/python-rstudio)


# Folders

This folder contains our extraction and loading codebase.

- `index.R` controller script. Use this to manipulate the data extraction loading process.
- `📁 renv` contains project specific dependency management as per the [renv](https://rstudio.github.io/renv/articles/renv.html) package.
- `📁 raw-hcup` local development folder containing .acs, .dta, .do and .csv files.
- `📁 R` local project functions
- `📁 documents` supplemental documents
- `📁 code` local scripts
- `📁 clean` local cleaned objects  



## ELT (Extraction Loading Transform) schematic


```mermaid
graph LR
classDef subgraph_padding fill:none,stroke:none
 subgraph lan [ELT]
 subgraph subgraph_padding1 [ ]
   style lan stroke-dasharray: 5 5
         subgraph  <b>E</b>xtraction
           n1[.acs]--Stata load program-->n2[.dta]
         end
         n2[.dta]---n3[.dta]
         subgraph <b>L</b>oading
           n3[.dta]--R-->n4[.parquet]
         end
         n4[.parquet]---n5[.parquet]
         subgraph <b>T</b>ransformation
            n5[.parquet]--DBT-DuckDB-->n6[analytical_files]
        end
        end
 
 end       
 class subgraph_padding1 subgraph_padding
```

## Infrastructure Summary

```mermaid
graph LR
classDef subgraph_padding fill:none,stroke:none

 subgraph subgraph_padding1 [ ]
  
        
        
         subgraph n1["Existing Drexel Infrastructure"]
            n6["Encrypted UHC Server"]--Arrow/DuckDB-->n5["R/Python-Git"]
            n5["R/Python-Git"]--Arrow/DuckDB-->n6["Encrypted UHC Server"]
        end
     
 
 end       
 class subgraph_padding1 subgraph_padding
```
