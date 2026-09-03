{{ config(materialized='view') }}

select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix
from {{ source('olist', 'olist_customers_dataset') }}

