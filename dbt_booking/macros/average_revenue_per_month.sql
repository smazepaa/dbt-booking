{% macro average_revenue_per_month(month) %}
    select
        h.name as hotel_name,
        sum(ro.price) as total_revenue,
        round(avg(ro.price), 2) as average_price_per_room
    from {{ ref('stg_hotels') }} h
    join {{ ref('stg_rooms') }} ro on h.hotel_id = ro.hotel_id
    join {{ ref('stg_reservation_rooms') }} rr on ro.room_id = rr.room_id
    join {{ ref('stg_reservations') }} r on rr.reservation_id = r.reservation_id
    where date_trunc('month', r.date_checkin) = '{{ month }}'
    group by
        h.hotel_id,
        h.name
    order by
        total_revenue desc
{% endmacro %}
