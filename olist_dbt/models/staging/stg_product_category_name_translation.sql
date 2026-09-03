{{ config(materialized='table') }}

SELECT
    source_data.category_name as category_name_portuguese, 

    CASE
        WHEN source_data.category_name = 'eletrodomesticos_2'
             AND source_data.product_category_name_english = 'home_appliances_2'
            THEN 'home_appliances'
        WHEN source_data.category_name = 'casa_conforto'
             AND source_data.product_category_name_english = 'home_confort'
            THEN 'home_comfort'
        WHEN source_data.category_name = 'casa_conforto_2'
             AND source_data.product_category_name_english = 'home_comfort_2'
            THEN 'home_comfort'
        ELSE source_data.product_category_name_english

    END AS category_name_english

FROM {{ source(
'raw', 'product_category_name_translation'
) }} AS source_data