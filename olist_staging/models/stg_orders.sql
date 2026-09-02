{{ config(materialized='view') }}

select
    order_id,
    customer_id,
    order_status,
    cast(order_purchase_timestamp as timestamp) as purchase_ts,
    cast(order_delivered_customer_date as timestamp) as delivered_customer_ts
from {{ source('olist', 'olist_orders_dataset') }}


