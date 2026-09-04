-- models/staging/stg_order_items.sql
-- do this sql before stg_products

{{ config(materialized='table') }}

SELECT
    category_name as category_name_portuguese, 

    -- correct spelling and duplicates
    CASE
        WHEN category_name = 'eletrodomesticos_2'
             AND product_category_name_english = 'home_appliances_2'
            THEN 'home_appliances'
        WHEN category_name = 'casa_conforto'
             AND product_category_name_english = 'home_confort'
            THEN 'home_comfort'
        WHEN category_name = 'casa_conforto_2'
             AND product_category_name_english = 'home_comfort_2'
            THEN 'home_comfort'
        ELSE product_category_name_english

    END AS category_name_english

FROM {{ source('raw', 'product_category_name_translation') }}