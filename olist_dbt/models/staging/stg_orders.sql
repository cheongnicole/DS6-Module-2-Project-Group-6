-- models/staging/stg_order_items.sql

{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    order_status,
    SAFE_CAST(order_purchase_timestamp AS TIMESTAMP) as order_purchase_timestamp,
    SAFE_CAST(order_approved_at AS TIMESTAMP) as order_approved_at,
    SAFE_CAST(order_delivered_carrier_date AS TIMESTAMP) as order_delivered_carrier_date,
    SAFE_CAST(order_delivered_customer_date AS TIMESTAMP) as order_delivered_customer_date,
    SAFE_CAST(order_estimated_delivery_date AS TIMESTAMP) as order_estimated_delivery_date

FROM {{ source('raw', 'olist_orders') }}