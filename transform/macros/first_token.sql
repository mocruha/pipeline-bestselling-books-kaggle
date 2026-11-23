{% macro first_token(column) %}
    {#- 'm; w' / 'm, w' / 'United States; United States' -> primeiro valor -#}
    nullif(trim(split_part(replace({{ column }}, ',', ';'), ';', 1)), '')
{% endmacro %}


{% macro has_multiple_tokens(column) %}
    {#- true quando a string carrega mais de um valor separado por ';' ou ',' -#}
    coalesce(
        length(trim({{ column }})) > 0
        and position(';' in replace({{ column }}, ',', ';')) > 0,
        false
    )
{% endmacro %}
