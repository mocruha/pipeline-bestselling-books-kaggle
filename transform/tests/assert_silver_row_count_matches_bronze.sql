{#- Silver é 1:1 com o bronze. Qualquer linha aqui é uma divergência de contagem. -#}

with silver as (

    select count(*) as n
    from {{ ref('stg_bronze__bestselling_books') }}

),

bronze as (

    select count(*) as n
    from {{ source('bronze', 'b_bestselling_books') }}

)

select silver.n as silver_rows, bronze.n as bronze_rows
from silver, bronze
where silver.n <> bronze.n
