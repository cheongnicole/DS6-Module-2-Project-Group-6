{{ config(materialized='table') }}

SELECT
    source_data.review_id,
    source_data.order_id,
    SAFE_CAST(review_score AS INT64) as review_score,
    source_data.review_comment_title,
    source_data.review_comment_message,
    SAFE_CAST(review_creation_date AS TIMESTAMP) as review_creation_date,
    SAFE_CAST(review_answer_timestamp AS TIMESTAMP) as review_answer_timestamp

FROM {{ source(
'raw', 'olist_order_reviews'
) }} AS source_data