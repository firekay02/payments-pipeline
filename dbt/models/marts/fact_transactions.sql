-- Incremental: after the first build, only rows loaded since the last run are processed.
-- unique_key means a re-processed transaction replaces its old row instead of duplicating.
{{ config(materialized='incremental', unique_key='transaction_id') }}

select
    t.transaction_id,
    md5(t.customer_id)                            as customer_key,
    md5(t.merchant_id)                            as merchant_key,
    to_char(t.transaction_date, 'YYYYMMDD')::int  as date_key,
    md5(t.channel)                                as channel_key,
    t.amount,
    t.fee,
    t.status,
    t.created_at,
    t.loaded_at
from {{ ref('stg_transactions') }} t

{% if is_incremental() %}
-- loaded_at (not created_at) so late-arriving transactions are still picked up
where t.loaded_at > (select coalesce(max(loaded_at), '1900-01-01') from {{ this }})
{% endif %}
