{{ config(materialized='view') }}

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS review_created_ts,
    CAST(review_answer_timestamp AS TIMESTAMP) AS review_answered_ts
FROM {{ source('ingestion', 'olist_order_reviews') }}
