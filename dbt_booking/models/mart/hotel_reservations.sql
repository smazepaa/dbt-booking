with reservations as (
    select
        reservation_id,
        customer_id,
        hotel_id,
        confirmed,
        date_checkin,
        date_checkout
    from {{ ref('stg_reservations') }}
),
customers as (
    select
        customer_id,
        name as customer_name
    from {{ ref('stg_customers') }}
),
hotels as (
    select
        h.hotel_id,
        h.name as hotel_name,
        c.name as city_name
    from {{ ref('stg_hotels') }} h
    join {{ ref('stg_hotel_city') }} hc on h.hotel_id = hc.hotel_id
    join {{ ref('stg_cities') }} c on hc.city_id = c.city_id
)
select
    r.reservation_id,
    c.customer_name,
    h.hotel_name,
    h.city_name,
    r.date_checkin,
    r.date_checkout,
    r.confirmed
from reservations r
join customers c on r.customer_id = c.customer_id
join hotels h on r.hotel_id = h.hotel_id
