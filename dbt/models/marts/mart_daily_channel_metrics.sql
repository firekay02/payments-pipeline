-- The table the dashboard reads: one row per day per channel.
select
    d.full_date,
    c.channel_name,
    count(*)                                                    as transactions,
    count(*) filter (where f.status = 'success')                as successful,
    round(100.0 * count(*) filter (where f.status = 'success') / count(*), 1) as success_rate_pct,
    sum(f.amount) filter (where f.status = 'success')           as successful_amount,
    sum(f.fee)    filter (where f.status = 'success')           as fee_revenue,
    coalesce(sum(f.amount) filter (where f.status = 'pending'), 0) as pending_amount
from {{ ref('fact_transactions') }} f
join {{ ref('dim_date') }}    d on d.date_key    = f.date_key
join {{ ref('dim_channel') }} c on c.channel_key = f.channel_key
group by 1, 2
