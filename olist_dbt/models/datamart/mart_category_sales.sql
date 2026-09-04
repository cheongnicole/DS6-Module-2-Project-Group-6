-- models/marts/mart_category_sales.sql

{{ config(materialized='table') }}

select
    p.product_category_name,
    sum(oi.price) as sales
from {{ ref('fct_order_items') }} as oi
inner join {{ ref('fct_orders') }} as o
    on oi.order_id = o.order_id
left join {{ ref('dim_products') }} as p
    on oi.product_id = p.product_id
where o.order_status = 'delivered'
group by
    1
