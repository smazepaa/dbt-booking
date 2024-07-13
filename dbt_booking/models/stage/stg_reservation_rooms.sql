select
    reservation_id,
    room_id
from {{ ref('raw_reservation_rooms') }}
