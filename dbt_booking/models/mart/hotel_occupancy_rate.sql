with reservations as (
    select
        reservation_id,
        hotel_id,
        date_checkin,
        date_checkout
    from {{ ref('stg_reservations') }}
),
hotels as (
    select
        h.hotel_id,
        h.name as hotel_name,
        c.name as city_name
    from {{ ref('stg_hotels') }} h
    join {{ ref('stg_hotel_city') }} hc on h.hotel_id = hc.hotel_id
    join {{ ref('stg_cities') }} c on hc.city_id = c.city_id
),
hotel_reservations as (
    select
        hotel_id,
        extract(month from date_checkin) as reservation_month,
        extract(year from date_checkin) as reservation_year,
        count(reservation_id) as monthly_reservations
    from reservations
    group by hotel_id, reservation_year, reservation_month
),
hotel_reservation_counts as (
    select
        hotel_id,
        count(distinct reservation_year || '-' || reservation_month) as months_count,
        sum(monthly_reservations) as total_reservations
    from hotel_reservations
    group by hotel_id
)
select
    h.city_name,
    h.hotel_name,
    round(hrc.total_reservations * 1.0 / hrc.months_count, 3) as avg_reservations_per_month
from hotels h
left join hotel_reservation_counts hrc on h.hotel_id = hrc.hotel_id
order by avg_reservations_per_month desc
