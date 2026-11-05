select
    md5(customer_id) as customer_key,
    customer_id,
    region,
    signup_date
from {{ ref('stg_customers') }}
