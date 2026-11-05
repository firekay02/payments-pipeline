
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select success_rate_pct
from "payments"."analytics"."mart_daily_channel_metrics"
where success_rate_pct is null



  
  
      
    ) dbt_internal_test