with revenue_by_room_class_cte as (
    {{ revenue_by_room_class(hotel_name='Martinez Inc', city_name='Lake Rogerbury') }}
)
select * from revenue_by_room_class_cte
