{{ config(materialized='table') }}

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state
FROM {{ ref('stg_sellers') }} s
