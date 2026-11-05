
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- A singular test: dbt fails the test if this query returns any rows.
select transaction_id, fee
from "payments"."analytics"."fact_transactions"
where fee < 0
  
  
      
    ) dbt_internal_test