select
    city_id,
    name,
    country_id
from {{ ref('raw_cities') }}
