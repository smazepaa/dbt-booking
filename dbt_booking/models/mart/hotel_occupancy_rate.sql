with reservations as (
    select
        reservation_id,
        hotel_id,
        date_checkin,
        date_checkout
    from {{ ref('stg_reservations') }}
),
rooms as (
    select
        room_id,
        hotel_id
    from {{ ref('stg_rooms') }}
),
hotels as (
    select
        hotel_id,
        name as hotel_name
    from {{ ref('stg_hotels') }}
)
select
    h.hotel_id,
    h.hotel_name,
    count(distinct r.room_id) as total_rooms,
    count(distinct rr.reservation_id) as total_reservations,
    round(count(distinct rr.reservation_id) * 100.0 / count(distinct r.room_id), 2) as occupancy_rate
from hotels h
left join rooms r on h.hotel_id = r.hotel_id
left join {{ ref('stg_reservation_rooms') }} rr on r.room_id = rr.room_id
group by
    h.hotel_id,
    h.hotel_name
