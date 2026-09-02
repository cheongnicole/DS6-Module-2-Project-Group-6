select
    customer_id,
    customer_unique_id
    -- remove customer_city if not present in stg_customers
from {{ ref('stg_customers') }} c
