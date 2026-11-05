select
    customer_id,
    trim(region) as region,
    signup_date
from "payments"."public"."raw_customers"