
  
    

  create  table "payments"."analytics"."dim_channel__dbt_tmp"
  
  
    as
  
  (
    select distinct
    md5(channel) as channel_key,
    channel      as channel_name,
    case when channel = 'card' then 'card' else 'mobile_money' end as channel_type
from "payments"."analytics"."stg_transactions"
  );
  