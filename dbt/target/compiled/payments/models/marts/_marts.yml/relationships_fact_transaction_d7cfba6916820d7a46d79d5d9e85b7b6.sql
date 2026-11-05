
    
    

with child as (
    select merchant_key as from_field
    from "payments"."analytics"."fact_transactions"
    where merchant_key is not null
),

parent as (
    select merchant_key as to_field
    from "payments"."analytics"."dim_merchant"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


