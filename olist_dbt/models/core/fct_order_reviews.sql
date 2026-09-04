-- models/core/fct_order_reviews.sql

{{ config(materialized = 'table') }}

with reviews as (
    select
        review_id,
        order_id,
        review_score,
        review_answer_timestamp
    from {{ ref('stg_order_reviews') }}
),

ranked_reviews as (
    select
        review_id,
        order_id,
        review_score,
        review_answer_timestamp,

        row_number() over (
            partition by order_id
            order by
                review_answer_timestamp desc nulls last,
                review_id desc
        ) as review_sequence

    from reviews
)

select
    review_id,
    order_id,
    review_score,
    review_answer_timestamp,
    review_sequence = 1 as latest_review
from ranked_reviews
