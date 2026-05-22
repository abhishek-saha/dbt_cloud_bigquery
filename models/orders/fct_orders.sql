with source_orders as (

    select *
    from {{ source('bigquery_source', 'orders') }}

),

transformed as (

    select
        order_id,
        order_date,
        customer_id,
        customer_name,
        city,
        state,
        product_id,
        product_name,
        category,

        quantity,
        unit_price,
        discount_pct,

        quantity * unit_price as gross_sales_amount,

        quantity * unit_price * (discount_pct / 100) as discount_amount,

        quantity * unit_price * (1 - discount_pct / 100) as net_sales_amount,

        payment_method,
        order_status,
        shipment_status,

        case
            when order_status = 'Completed' then true
            else false
        end as is_completed_order,

        case
            when order_status = 'Cancelled' then true
            else false
        end as is_cancelled_order,

        case
            when order_status = 'Returned' then true
            else false
        end as is_returned_order,

        extract(year from order_date) as order_year,
        extract(month from order_date) as order_month,
        date_trunc(order_date, month) as order_month_start

    from source_orders

)

select *
from transformed