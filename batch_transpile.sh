#!/usr/bin/env bash
# batch_transpile.sh - transpila .pas para .cs com barra de progresso e contagem de erros/sucessos
# Uso: ./batch_transpile.sh LOGFILE DIR [DIR...]

log_file="$1"
shift || { echo "Uso: $0 LOGFILE DIR [DIR...]" >&2; exit 1; }

# zera o log
: > "$log_file"

# coleta todos os arquivos .pas em um array
mapfile -d '' files < <(find "$@" -type f -name '*.pas' ! -name '*.designer.pas' -print0)
total=${#files[@]}

if (( total == 0 )); then
    echo "Nenhum arquivo .pas encontrado em: $*"
    exit 0
fi

# inicializa contadores
count=0
success=0
fail=0

# largura da barra de progresso (em caracteres)
bar_width=40

process_file() {
    local src="$1"
    local out="${src%.pas}.cs"

    if python pas2cs.py "$src" > "$out" 2>>"$log_file"; then
        ((success++))
    else
        ((fail++))
        echo "ERRO em $src" >>"$log_file"
    fi
}

draw_progress() {
    local percent=$(( count * 100 / total ))
    local hashes=$(( percent * bar_width / 100 ))
    local dots=$(( bar_width - hashes ))
    # constrói a barra
    local bar
    bar=$(printf "%0.s#" $(seq 1 $hashes))
    local space
    space=$(printf "%0.s." $(seq 1 $dots))
    # imprime sem quebra de linha, sobrescrevendo a linha anterior
    echo -ne "[$bar$space] $percent% ($count/$total) OK:$success ERR:$fail\r"
}

# loop principal
for src in "${files[@]}"; do
    process_file "$src"
    ((count++))
    draw_progress
done

# quebra de linha final e resumo
echo -e "\nConcluído: total=$total, ok=$success, erros=$fail"
