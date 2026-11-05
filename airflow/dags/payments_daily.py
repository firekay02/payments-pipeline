from datetime import datetime, timedelta

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

PROJECT = "/opt/airflow/project"

with DAG(
    dag_id="payments_daily",
    schedule="@daily",
    start_date=datetime(2026, 11, 1),
    catchup=False,
    default_args={"retries": 2, "retry_delay": timedelta(minutes=5)},
) as dag:
    generate = BashOperator(
        task_id="generate",
        bash_command=f"cd {PROJECT} && python ingestion/generate_fake_data.py --days 1 --seed $(date +%Y%m%d)",
    )
    load = BashOperator(
        task_id="load",
        bash_command=f"cd {PROJECT} && python ingestion/load_to_postgres.py",
    )
    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {PROJECT}/dbt && dbt build --profiles-dir .",
    )

    generate >> load >> dbt_build