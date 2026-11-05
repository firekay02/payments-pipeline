
  create view "payments"."analytics"."stg_customers__dbt_tmp"
    
    
  as (
    select
    customer_id,
    trim(region) as region,
    signup_date
from "payments"."public"."raw_customers"
  );