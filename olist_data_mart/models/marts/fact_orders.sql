{{ config(materialized='table') }}

with items as (
    select
        order_id,
        count(*) as item_count,
        sum(price) as total_item_value
    from {{ ref('stg_order_items') }}
    group by order_id
),

payments as (
    select
        order_id,
        sum(payment_value) as total_payment_value,
        array_agg(distinct payment_type)[offset(0)] as payment_type  -- pick one type
    from {{ ref('stg_payments') }}
    group by order_id
),

reviews as (
    select
        order_id,
        avg(review_score) as avg_review_score
    from {{ ref('stg_order_reviews') }}
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.purchase_ts,
    o.delivered_customer_ts,
    i.item_count,
    i.total_item_value,
    p.total_payment_value,
    p.payment_type,
    r.avg_review_score
from {{ ref('stg_orders') }} o
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id
left join reviews r on o.order_id = r.order_id


