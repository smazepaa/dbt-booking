select
    hotel_id,
    city_id
from {{ ref('raw_hotel_city') }}
