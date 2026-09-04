-- models/marts/mart_monthly_sales.sql

{{ config(materialized='table') }}

select
    date_trunc(date(order_purchase_timestamp), month) as month_start_date,
    sum(order_total_price) as sales,
    count(distinct order_id) as order_count
from {{ ref('fct_orders') }}
where order_status='delivered' and
order_purchase_timestamp is not null
group by 1
order by 1
