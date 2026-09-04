-- models/staging/stg_order_items.sql

{{ config(materialized='table') }}

SELECT
    review_id,
    order_id,
    SAFE_CAST(review_score AS INT64) as review_score,
    review_comment_title,
    review_comment_message,
    SAFE_CAST(review_creation_date AS TIMESTAMP) as review_creation_date,
    SAFE_CAST(review_answer_timestamp AS TIMESTAMP) as review_answer_timestamp

FROM {{ source('raw', 'olist_order_reviews') }}