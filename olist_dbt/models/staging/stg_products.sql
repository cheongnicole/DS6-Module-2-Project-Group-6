-- models/staging/stg_order_items.sql

{{ config(materialized='table') }}

SELECT
    p.product_id,
    -- Patch empty categories to Uncategorized
    coalesce(nullif(trim(t.category_name_english), ''), 'Uncategorized') 
        as product_category_name,
    SAFE_CAST(p.product_name_lenght AS INT64) as product_name_length,
    SAFE_CAST(p.product_description_lenght AS INT64) as product_description_length,
    SAFE_CAST(p.product_photos_qty AS INT64) as product_photos_qty,
    SAFE_CAST(p.product_weight_g AS INT64) as product_weight_g,
    SAFE_CAST(p.product_length_cm AS INT64) as product_length_cm,
    SAFE_CAST(p.product_height_cm AS INT64) as product_height_cm,
    SAFE_CAST(p.product_width_cm AS INT64) as product_width_cm

FROM {{ source('raw', 'olist_products') }} AS p

-- Translate to English
LEFT JOIN {{ ref('stg_product_category_name_translation') }} as t
    on lower(trim(p.product_category_name)) = lower(trim(t.category_name_portuguese))