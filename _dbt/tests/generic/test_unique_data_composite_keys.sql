{% test test_unique_data_composite_keys(model) %}

{{ dbt_utils.test_unique_combination_of_columns(
    model,
    combination_of_columns=[
        'dataset_id', 'dataset_version', 'version', 'var_name',
        'observation_id', 'strata_id', 'year', 'month', 'day',
        'geo', 'iso2', 'value_iteration'
    ]
) }}

{% endtest %}