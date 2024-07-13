select
    customer_id,
    name,
    email,
    phone_number
from {{ ref('raw_customers') }}
