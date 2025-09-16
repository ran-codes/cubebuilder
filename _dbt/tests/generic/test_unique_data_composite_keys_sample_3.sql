{% test test_unique_data_composite_keys_sample_3(model) %}

with sampled_data as (
    select *
    from {{ model }}
    order by random()  -- This creates a random order
    limit 1000000     -- This limits to 1 million rows
),

grouped_data as (
    select
        dataset_id,
        dataset_version,
        version,
        var_name,
        observation_id,
        strata_id,
        year,
        month,
        day,
        geo,
        iso2,
        value_iteration,
        count(*) as row_count
    from sampled_data
    group by
        dataset_id,
        dataset_version,
        version,
        var_name,
        observation_id,
        strata_id,
        year,
        month,
        day,
        geo,
        iso2,
        value_iteration
    having count(*) > 1
)

select *
from grouped_data

{% endtest %}