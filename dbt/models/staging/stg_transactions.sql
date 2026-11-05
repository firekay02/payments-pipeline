-- Clean the raw transactions: tidy text, drop rows with no amount, add a date column.
with src as (
    select * from {{ source('raw', 'raw_transactions') }}
)

select
    transaction_id,
    customer_id,
    merchant_id,
    trim(channel)                  as channel,
    amount::numeric(12, 2)         as amount,
    coalesce(fee, 0)::numeric(12, 2) as fee,
    lower(trim(status))            as status,
    created_at,
    created_at::date               as transaction_date,
    loaded_at
from src
where amount is not null
