with base as (
    select
        order_id,
        review_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date,
        review_answer_timestamp,
        row_number() over (
            partition by order_id, review_id
            order by review_creation_date
        ) as rn
    from {{ source('olist','olist_order_reviews_dataset') }}
)
select
    order_id,
    review_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
from base
where rn = 1

