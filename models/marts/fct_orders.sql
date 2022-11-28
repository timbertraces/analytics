with shopify_orders as (
    select
        date(processed_timestamp) as date,
        'shopify' as platform,
        order_number,
        customer_id,
        total_tax,
        total_price as total_revenue,
        refund_subtotal,
        refund_total_tax,
        case
            when refund_total_tax > 0 then order_adjusted_total + refund_total_tax
            else order_adjusted_total
        end as total_revenue_adjusted,
        total_tax - refund_total_tax as total_tax_adjusted,
        shipping_cost
    from {{ ref('shopify', 'shopify__orders') }}
    where financial_status != 'voided'
),

all_orders as (
select * from shopify_orders    
)

select * from all_orders