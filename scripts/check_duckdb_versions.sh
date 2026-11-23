#!/usr/bin/env bash
# Fail when the duckdb CLI and the project's duckdb library speak different file formats.
# Run from anywhere in the repo.
set -euo pipefail
cd "$(dirname "$0")/.."

PY=$(uv run python -c 'import duckdb;print(duckdb.__version__)' 2>/dev/null || true)
CLI=$(duckdb --version 2>/dev/null | awk '{print $1}' | sed 's/^v//')

if [[ -z "$PY" || -z "$CLI" ]]; then
  echo "ERRO: nao consegui detectar as versoes (PY='$PY' CLI='$CLI')" >&2
  exit 1
fi

PY_MAJOR=${PY%%.*}
CLI_MAJOR=${CLI%%.*}

echo "python duckdb : $PY"
echo "cli duckdb    : $CLI"

if [[ "$PY_MAJOR" != "$CLI_MAJOR" ]]; then
  echo "ERRO: major divergente — arquivos escritos pelo Python ($PY) nao abrem no CLI ($CLI)." >&2
  exit 1
fi
echo "OK: majors alinhados."