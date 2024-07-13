select
    reservation_id,
    customer_id,
    hotel_id,
    confirmed,
    date_checkin,
    date_checkout
from {{ ref('raw_reservations') }}
