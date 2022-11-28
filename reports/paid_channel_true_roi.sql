with
    order_channel as (
        select
            orders.date,
            orders.platform,
            ifnull(transactions.source,'(none)') source,
            ifnull(transactions.medium,'(none)') medium,
            ifnull(transactions.campaign_name,'(none)') campaign_name,
            count(orders.order_number) orders,
            sum(orders.total_revenue_adjusted) total_revenue_adjusted,
            sum(orders.total_tax_adjusted) total_tax_adjusted,
            sum(orders.shipping_cost) shipping_cost,
            sum(0) as product_cost
        from {{ ref("fct_orders") }} orders

        left join
            {{ ref("fct_transactions_channels") }} transactions
            on (orders.order_number = transactions.order_number)

        group by 1, 2, 3, 4, 5
    ),

    all_channels as (
        select
            date,
            source,
            medium,
            campaign_name
        from order_channel

        union distinct

        select
            date,
            source,
            medium,
            campaign_name
        from {{ ref('fct_paid_channels') }}
    ),

    final as (
        select
            channel.date,
            channel.source,
            ifnull(stats.account_name,'(none)') account_name,
            channel.medium,
            channel.campaign_name,
            ifnull(orderc.platform,'(none)') platform,                      
            ifnull(orderc.total_revenue_adjusted,0) total_revenue_adjusted,
            ifnull(orderc.total_tax_adjusted,0) total_tax_adjusted,
            ifnull(orderc.orders,0) orders,
            ifnull(orderc.shipping_cost,0) shipping_cost,
            ifnull(orderc.product_cost,0) product_cost,
            ifnull(stats.ad_cost,0) ad_cost,
        from all_channels channel

        left join
            order_channel orderc
            on (channel.date = orderc.date)
            and (channel.source = orderc.source)
            and (channel.medium = orderc.medium)
            and (channel.campaign_name = orderc.campaign_name)

        left join {{ref('fct_paid_channels')}} stats
            on (channel.date = stats.date) 
            and (channel.source = stats.source) 
            and (channel.medium = stats.medium) 
            and (channel.campaign_name = stats.campaign_name)     
    )


select * from final
