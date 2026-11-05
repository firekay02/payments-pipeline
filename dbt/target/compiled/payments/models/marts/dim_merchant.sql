select
    md5(merchant_id) as merchant_key,
    merchant_id,
    merchant_name,
    category
from "payments"."analytics"."stg_merchants"