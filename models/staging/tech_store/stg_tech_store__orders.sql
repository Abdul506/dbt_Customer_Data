{{
  config(
    materialized='incremental',
    unique_key='order_id',
  )
}}

with

orders as (

    select * from {{ source('tech_store', 'orders') }}

),

final as (

    select
        id as order_id,
        productid as product_id,
        quantity,
        userid as employee_id,
        customerid as customer_id,
        timestamp(left(`datetime`, length(datetime)-6)) as created_at,
        {{ utc_to_est('datetime') }} as created_at_est,
        date(datetime) as created_at_dt

    from orders

)

select * from final
