{% macro reservation_trends(hotel_name, city_name) %}
with reservations as (
    select
        r.reservation_id,
        r.customer_id,
        r.hotel_id,
        r.date_checkin,
        r.date_checkout,
        r.confirmed,
        h.name as hotel_name,
        c.name as city_name
    from {{ ref('stg_reservations') }} r
    join {{ ref('stg_hotels') }} h on r.hotel_id = h.hotel_id
    join {{ ref('stg_hotel_city') }} hc on h.hotel_id = hc.hotel_id
    join {{ ref('stg_cities') }} c on hc.city_id = c.city_id
    where h.name = '{{ hotel_name }}' and c.name = '{{ city_name }}'
)
select
    date_trunc('month', date_checkin) as month,
    count(reservation_id) as total_reservations,
    count(case when confirmed then 1 end) as confirmed_reservations,
    avg(datediff('day', date_checkin, date_checkout)) as avg_stay_length
from reservations
group by
    date_trunc('month', date_checkin)
order by
    month
{% endmacro %}
