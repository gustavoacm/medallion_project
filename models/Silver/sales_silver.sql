-- =================================
-- Model: sales_silver_incremental
-- Layer: Silver
-- Description: Clean sales data - incremental load
-- Materialization: incremental
-- =================================

{{ config(materialized='incremental',
          unique_key='sale_id') }}

SELECT
    sale_id,
    TRY_TO_DATE(date)   AS date,
    amount,
    client_id,
    product,
    status,
    load_date
FROM {{ source('bronze', 'sales_bronze') }}
WHERE amount        IS NOT NULL
AND client_id       IS NOT NULL
AND amount          > 0

{% if is_incremental() %}
    AND (
        -- Registros nuevos por ID
        sale_id > (SELECT MAX(sale_id) FROM {{ this }})
        OR
        -- Registros modificados por fecha
        load_date > (SELECT MAX(load_date) FROM {{ this }})
    )
{% endif %}