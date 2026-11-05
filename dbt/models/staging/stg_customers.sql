select
    customer_id,
    trim(region) as region,
    signup_date
from {{ source('raw', 'raw_customers') }}
