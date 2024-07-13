with rooms as (
    select
        room_id,
        hotel_id,
        class as room_class,
        price as room_price
    from {{ ref('stg_rooms') }}
),
hotels as (
    select
        hotel_id,
        name as hotel_name,
        address as hotel_address
    from {{ ref('stg_hotels') }}
),
hotel_city as (
    select
        hotel_id,
        city_id
    from {{ ref('stg_hotel_city') }}
),
cities as (
    select
        city_id,
        name as city_name,
        country_id
    from {{ ref('stg_cities') }}
),
countries as (
    select
        country_id,
        name as country_name
    from {{ ref('stg_countries') }}
),
reservation_rooms as (
    select
        reservation_id,
        room_id
    from {{ ref('stg_reservation_rooms') }}
),
reservations as (
    select
        reservation_id,
        date_checkin,
        date_checkout
    from {{ ref('stg_reservations') }}
)
select
    ro.room_id,
    ro.room_class,
    ro.room_price,
    h.hotel_name,
    h.hotel_address,
    c.city_name,
    co.country_name,
    min(r.date_checkin) as reservation_checkin,
    max(r.date_checkout) as reservation_checkout
from rooms ro
join hotels h on ro.hotel_id = h.hotel_id
join hotel_city hc on h.hotel_id = hc.hotel_id
join cities c on hc.city_id = c.city_id
join countries co on c.country_id = co.country_id
left join reservation_rooms rr on ro.room_id = rr.room_id
left join reservations r on rr.reservation_id = r.reservation_id
group by
    ro.room_id,
    ro.room_class,
    ro.room_price,
    h.hotel_name,
    h.hotel_address,
    c.city_name,
    co.country_name
