with reservations as (
    select
        reservation_id,
        customer_id,
        hotel_id,
        date_checkin,
        date_checkout,
        confirmed
    from {{ ref('stg_reservations') }}
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
