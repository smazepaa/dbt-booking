select
    room_id,
    hotel_id,
    class,
    price
from {{ ref('raw_rooms') }}
