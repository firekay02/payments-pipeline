
  
    

  create  table "payments"."analytics"."dim_date__dbt_tmp"
  
  
    as
  
  (
    -- One row per day between the first and last transaction.
with bounds as (
    select min(transaction_date) as d0, max(transaction_date) as d1
    from "payments"."analytics"."stg_transactions"
),

days as (
    select generate_series(d0, d1, interval '1 day')::date as full_date
    from bounds
)

select
    to_char(full_date, 'YYYYMMDD')::int        as date_key,
    full_date,
    extract(isodow from full_date)::int        as day_of_week,
    trim(to_char(full_date, 'Day'))            as day_name,
    extract(month from full_date)::int         as month,
    extract(year from full_date)::int          as year,
    extract(isodow from full_date) in (6, 7)   as is_weekend
from days
  );
  