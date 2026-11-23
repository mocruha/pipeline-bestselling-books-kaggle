# pipeline-books

Pipeline de ingestão (dlt) + transformação (dbt) com DuckDB.

## Requisito de ferramenta: duckdb CLI >= 2.0.0

Os bancos do repo (`data/bronze/*.duckdb`, `transform/*.duckdb`) são escritos pelo
`duckdb` do venv (hoje `2.0.0`, storage version 69). O CLI oficial precisa ser da
mesma série major, senão falha ao abrir:

    IO Error: Trying to read a database file with version number 69,
    but we can only read versions between 64 and 68.

Instalação do CLI alinhado (binário oficial, NÃO o pacote `duckdb-cli` do PyPI,
que ainda está em 1.5.6):

    mkdir -p ~/.local/opt/duckdb-2.0.0
    curl -sSL https://github.com/duckdb/duckdb/releases/download/v2.0.0/duckdb-cli-linux-amd64.tar.gz \
      | tar xz -C ~/.local/opt/duckdb-2.0.0
    uv tool uninstall duckdb-cli          # o shim dele ocupa ~/.local/bin/duckdb
    ln -sfn ~/.local/opt/duckdb-2.0.0/duckdb ~/.local/bin/duckdb
    hash -r

Verificação: `./scripts/check_duckdb_versions.sh` deve imprimir `OK: majors alinhados.`

## Comandos

    uv sync
    uv run python src/ingestion_duckdb.py     # bronze: data/bronze/bestselling_books.duckdb
    cd transform && uv run dbt build          # silver: dev.duckdb (schema silver)

## Arquitetura

Medalhão: **bronze** (dlt, cru) → **silver** (dbt, tipado 1:1) → **gold** (star
schema, próxima etapa). A convenção do dbt está em `transform/README.md`.

## Consultas

    duckdb data/bronze/bestselling_books.duckdb \
      "select count(*) from bronze.b_bestselling_books"

    duckdb transform/dev.duckdb \
      -c "ATTACH '../data/bronze/bestselling_books.duckdb' AS bronze (READ_ONLY);
          select * from silver.stg_bronze__bestselling_books limit 10"