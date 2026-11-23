with source as (

    select *
    from {{ source('bronze', 'b_bestselling_books') }}

),

typed as (

    select
        cast(date as date) as list_date,
        trim(country)      as country,
        cast(rank as integer) as rank,
        trim(title)        as title,
        trim(author)       as author_raw,
        trim(nationality)  as nationality_raw,
        trim(gender)       as gender_raw,
        trim(entry_id)     as entry_id,
        trim(publisher)    as publisher_name,
        trim(publication_country) as publication_country,
        _dlt_id
    from source

),

flattened as (

    select
        list_date,
        country,
        rank,
        title,
        {{ first_token('author_raw') }}                           as primary_author,
        {{ has_multiple_tokens('author_raw') }}                   as is_multi_author,
        {{ first_token('nationality_raw') }}                      as nationality,
        {{ has_multiple_tokens('nationality_raw') }}              as is_multi_nationality,
        coalesce(lower({{ first_token('gender_raw') }}), 'unknown') as gender,
        {{ has_multiple_tokens('gender_raw') }}                   as is_multi_gender,
        nullif(entry_id, '')                                      as entry_id,
        coalesce(nullif(publisher_name, ''), 'unknown')           as publisher_name,
        coalesce(nullif(publication_country, ''), 'unknown')      as publication_country,
        author_raw,
        nationality_raw,
        gender_raw,
        _dlt_id
    from typed

)

select * from flattened
