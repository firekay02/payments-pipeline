
    
    

with all_values as (

    select
        channel as value_field,
        count(*) as n_records

    from "payments"."analytics"."stg_transactions"
    group by channel

)

select *
from all_values
where value_field not in (
    'MTN','Telecel','AirtelTigo','card'
)


