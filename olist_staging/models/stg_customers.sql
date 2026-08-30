{{ config(materialized='view') }}

SELECT
    order_id,
    customer_id,
    CAST(order_purchase_timestamp AS TIMESTAMP) AS purchase_ts,
    CAST(order_delivered_customer_date AS TIMESTAMP) AS delivered_ts,
    order_status
FROM {{ source('ingestion', 'olist_orders') }}
