select
    country_id,
    name
from {{ ref('raw_countries') }}
