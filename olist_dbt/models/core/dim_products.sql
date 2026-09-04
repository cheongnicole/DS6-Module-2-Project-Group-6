-- models/core/dim_products.sql

{{ config(materialized='table') }}

SELECT
    product_id,
    product_category_name

FROM {{ source(
'staging', 'stg_products'
) }}