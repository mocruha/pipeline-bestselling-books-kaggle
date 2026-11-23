# transform (dbt + DuckDB)

Pipeline medalhão: **bronze** (dlt) → **silver** (aqui) → **gold** (próxima etapa).

## Convenções

- Nome de modelo de staging: `stg_<source>__<entidade>`.
- **Só `stg_*` usa `source()`.** Gold consome `ref()` de silver, nunca a source.
- Silver é **1:1 com o bronze**: `view`, sem `group by` / `join` / `distinct`.
- Schema = nome da camada (`silver`), via `macros/generate_schema_name.sql`.

## Layout

```
models/staging/_sources.yml                      source bronze (read-only)
models/staging/stg_bronze__bestselling_books.sql bronze tipado e conformado
models/staging/_models.yml                       contrato de testes
macros/first_token.sql                           multivalorado -> escalar + flag
tests/assert_silver_row_count_matches_bronze.sql paridade 1:1
tests/assert_silver_grain_is_unique.sql          grão (list_date, country, rank)
```

## Comandos

    cd transform
    uv run dbt build --profiles-dir ~/.dbt

## Consultando

O `dev.duckdb` só tem os views do silver; o bronze precisa ser anexado de novo
fora do dbt:

    duckdb dev.duckdb -c "ATTACH '../data/bronze/bestselling_books.duckdb' AS bronze (READ_ONLY);
      select * from silver.stg_bronze__bestselling_books limit 10"
