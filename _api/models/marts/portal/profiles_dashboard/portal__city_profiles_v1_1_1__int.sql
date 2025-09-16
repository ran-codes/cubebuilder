WITH

base_variables  as (
    SELECT
    'Base' as variable_type,
    geo, 
    observation_id as salid, 
    iso2, 
    year, 
    CAST(year AS INTEGER) as year_year_numeric,
    var_name as upstream_variable ,
    value, 
    cast(value as float) as value_numeric,
    value_type, source, public
    FROM {{ ref('core__admin_cube') }}
    WHERE var_name IN (
        'SECPOV', 'PRJPD', 'APSPM25MEAN', 'CNSMINUN', 'SECGINICONS', 
        'BECCZ', 'TMPMEAN', 'CNSCROWD25BR', 'BECPOPDENS', 'BECADAREA',
        'BECBYLANELENGTH', 'SECGDPGPPC', 'SECGINIINC', 'BECPERCAPCO2',
        'BECGSPCT', 'BECPCTURBAN', 'SVYOVWTCH', 'SPVHTMED', 'SPVSMKCUR',
        'SPVDBDX2', 'SPVMAM2YRS', 'SPVBMIOVOB', 'SPVPAP3YRS', 'SPVHLTHFP',
        'SPVDBDX1', 'SPVBMIOBESE', 'CNSWALLDUR1', 'CNSFLOOR', 'CNSWATNET',
        'CNSMINHS', 'CNSMINPR', 'CNSLABPART', 'BECTOTCO2'
    )
    AND geo = 'L1AD'
)

select * from base_variables