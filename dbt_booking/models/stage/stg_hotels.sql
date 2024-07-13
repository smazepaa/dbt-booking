select
    hotel_id,
    name,
    address,
    phone_number
from {{ ref('raw_hotels') }}
