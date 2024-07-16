with monthly_revenue as (
    {{ average_revenue_per_month('2024-01-01') }}
)
select * from monthly_revenue
