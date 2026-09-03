{{ config(materialized='table') }}

SELECT
    source_data.order_id,
    source_data.customer_id,
    source_data.order_status,
    SAFE_CAST(order_purchase_timestamp AS TIMESTAMP) as order_purchase_timestamp,
    SAFE_CAST(order_approved_at AS TIMESTAMP) as order_approved_at,
    SAFE_CAST(order_delivered_carrier_date AS TIMESTAMP) as order_delivered_carrier_date,
    SAFE_CAST(order_delivered_customer_date AS TIMESTAMP) as order_delivered_customer_date,
    SAFE_CAST(order_estimated_delivery_date AS TIMESTAMP) as order_estimated_delivery_date

FROM {{ source(
'raw', 'olist_orders'
) }} AS source_data