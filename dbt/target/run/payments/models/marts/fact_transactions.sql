
      
        
        
        delete from "payments"."analytics"."fact_transactions" as DBT_INTERNAL_DEST
        where (transaction_id) in (
            select distinct transaction_id
            from "fact_transactions__dbt_tmp145045394292" as DBT_INTERNAL_SOURCE
        );

    

    insert into "payments"."analytics"."fact_transactions" ("transaction_id", "customer_key", "merchant_key", "date_key", "channel_key", "amount", "fee", "status", "created_at", "loaded_at")
    (
        select "transaction_id", "customer_key", "merchant_key", "date_key", "channel_key", "amount", "fee", "status", "created_at", "loaded_at"
        from "fact_transactions__dbt_tmp145045394292"
    )
  