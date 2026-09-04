-- models/staging/stg_order_items.sql

{{ config(materialized='table') }}

SELECT
    order_id,
    SAFE_CAST(order_item_id AS INT64) as order_item_id,
    product_id,
    seller_id,
    SAFE_CAST(shipping_limit_date AS TIMESTAMP) as shipping_limit_date,
    SAFE_CAST(price AS FLOAT64) as price,
    SAFE_CAST(freight_value AS FLOAT64) as freight_value

FROM {{ source('raw', 'olist_order_items') }} 