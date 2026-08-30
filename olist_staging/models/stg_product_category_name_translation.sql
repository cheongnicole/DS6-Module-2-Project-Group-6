{{ config(materialized='view') }}

SELECT
    product_category_name,
    product_category_name_english
FROM {{ source('ingestion', 'product_category_name_translation') }}
