select
    p.product_id,
    c.product_category_name as product_category_name_translation
from {{ ref('stg_products') }} p
left join {{ ref('stg_product_category_name_translation') }} c
    on p.product_category_name = c.product_category_name
