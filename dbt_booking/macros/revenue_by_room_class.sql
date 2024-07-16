{% macro revenue_by_room_class(hotel_name=null, city_name=null) %}
    with reservations as (
        select
            reservation_id,
            date_checkin,
            date_checkout,
            hotel_id
        from {{ ref('stg_reservations') }}
    ),
    rooms as (
        select
            room_id,
            hotel_id,
            class as room_class,
            price as room_price
        from {{ ref('stg_rooms') }}
    ),
    reservation_rooms as (
        select
            reservation_id,
            room_id
        from {{ ref('stg_reservation_rooms') }}
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
        ro.room_class,
        count(distinct rr.reservation_id) as total_reservations,
        avg(ro.room_price * datediff('day', res.date_checkin, res.date_checkout)) as average_revenue
    from rooms ro
    join reservation_rooms rr on ro.room_id = rr.room_id
    join reservations res on rr.reservation_id = res.reservation_id
    join hotels h on ro.hotel_id = h.hotel_id
    where 1=1
    {% if hotel_name %}
        and h.hotel_name = '{{ hotel_name }}'
    {% endif %}
    {% if city_name %}
        and h.city_name = '{{ city_name }}'
    {% endif %}
    group by
        ro.room_class,
        h.hotel_name,
        h.city_name
    order by
        ro.room_class
{% endmacro %}
