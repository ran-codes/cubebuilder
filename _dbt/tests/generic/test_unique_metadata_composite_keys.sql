{% test test_unique_metadata_composite_keys(model) %}

{{ dbt_utils.test_unique_combination_of_columns(
    model,
    combination_of_columns=[
        'dataset_id', 'dataset_version', 'version', 'var_name',
        'strata_id', 'year', 'month', 'day',
        'geo', 'iso2'
    ]
) }}

{% endtest %}