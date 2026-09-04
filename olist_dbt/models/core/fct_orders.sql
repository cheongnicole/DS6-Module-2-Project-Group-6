-- models/core/fct_orders.sql

{{ config(materialized = 'table') }}

with orders as (
    select
        order_id,
        order_status,
        order_purchase_timestamp,
        order_delivered_customer_date
    from {{ ref('stg_orders') }}
),

order_totals as (
    select
        order_id,
        sum(price) as order_total_price
    from {{ ref('stg_order_items') }}
    group by order_id
)

select
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    cast(coalesce(t.order_total_price, 0) as float64) as order_total_price
from orders as o
left join order_totals as t
    on o.order_id = t.order_id
