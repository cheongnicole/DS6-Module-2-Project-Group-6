-- models/marts/mart_delivery_vs_review.sql

{{ config(materialized = 'table') }}

with delivered_orders as (
    select
        order_id,
        order_purchase_timestamp,
        order_delivered_customer_date
    from {{ ref('fct_orders') }}
    where order_status = 'delivered'
      and order_purchase_timestamp is not null
      and order_delivered_customer_date is not null
),

latest_reviews as (
    select
        order_id,
        review_score
    from {{ ref('fct_order_reviews') }}
    where latest_review = true
)

select
    o.order_id,
    timestamp_diff(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp,
        day
    ) as days_to_deliver,
    r.review_score

from delivered_orders as o
inner join latest_reviews as r
    on o.order_id = r.order_id
