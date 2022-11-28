with
    google_analytics as (
        select 
        date,
        property,
        campaign_id,
        campaign_name,
        medium,
        source,
        order_number
    from {{ ref("stg_google_analytics__ecommerce_overview_extended") }}
    )

select *
from google_analytics
