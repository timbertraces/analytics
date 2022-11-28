select
    date,
    property,
    campaign_id,
    campaign_name,
    medium,
    source,
    cast(replace(transaction_id, '#', '') as int) as order_number
from {{ source("google_analytics", "ecommerce_overview_extended") }}
