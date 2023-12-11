{{
  config(
    materialized='incremental',
    unique_key='customer_id',
  )
}}
    
with

customers as (

    select * from {{ source('tech_store', 'customer') }}

),

final as (

    select
        id as customer_id,
        name as customer_name,
        cityid as city_id,
        mainsalesrepid as main_employee_id,
        timestamp(left(`createdatetime`, length(createdatetime)-6)) as created_at,
        {{ utc_to_est('createdatetime') }} as created_at_est,
        timestamp(left(`updatedatetime`, length(updatedatetime)-6)) as updated_at,
        {{ utc_to_est('updatedatetime') }} as updated_at_est,
        iff(active = 'yes', true, false) as is_active
    
    from customers

)

select * from final
