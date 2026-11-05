
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select merchant_key
from "payments"."analytics"."dim_merchant"
where merchant_key is null



  
  
      
    ) dbt_internal_test