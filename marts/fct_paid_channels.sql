with
    google_ads as (
        select
            date_day as date,
            account_name,
            'google' as source,
            'cpc' as medium,
            campaign_name,
            spend as ad_cost,
            clicks

        from {{ ref("google_ads", "google_ads__campaign_report") }}
    )

select *
from google_ads
