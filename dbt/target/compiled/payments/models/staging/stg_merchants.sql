select
    merchant_id,
    trim(merchant_name) as merchant_name,
    lower(trim(category)) as category
from "payments"."public"."raw_merchants"