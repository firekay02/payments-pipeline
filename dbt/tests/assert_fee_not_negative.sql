-- A singular test: dbt fails the test if this query returns any rows.
select transaction_id, fee
from {{ ref('fact_transactions') }}
where fee < 0
