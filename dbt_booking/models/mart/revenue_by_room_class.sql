with reservations as (
    select
        reservation_id,
        date_checkin,
        date_checkout
    from {{ ref('stg_reservations') }}
),
rooms as (
    select
        room_id,
        class as room_class,
        price as room_price
    from {{ ref('stg_rooms') }}
),
reservation_rooms as (
    select
        reservation_id,
        room_id
    from {{ ref('stg_reservation_rooms') }}
)
select
    r.room_class,
    count(distinct rr.reservation_id) as total_reservations,
    sum(r.room_price * datediff('day', res.date_checkin, res.date_checkout)) as total_revenue
from rooms r
join reservation_rooms rr on r.room_id = rr.room_id
join reservations res on rr.reservation_id = res.reservation_id
group by
    r.room_class
