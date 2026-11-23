{#- O grão (list_date, country, rank) deve ser único. Qualquer linha aqui é duplicata. -#}

select
    list_date,
    country,
    rank,
    count(*) as n
from {{ ref('stg_bronze__bestselling_books') }}
group by 1, 2, 3
having count(*) > 1
