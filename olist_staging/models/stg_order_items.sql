with base as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        row_number() over (
            partition by order_id, order_item_id
            order by shipping_limit_date
        ) as rn
    from {{ source('olist','olist_order_items_dataset') }}
)
select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
from base
where rn = 1
