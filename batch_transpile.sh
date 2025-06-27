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

# processa em lotes para evitar 'argument list too long'
batch_size=100
count=0
success=0
fail=0
bar_width=40

draw_progress() {
    local percent=$(( count * 100 / total ))
    local hashes=$(( percent * bar_width / 100 ))
    local dots=$(( bar_width - hashes ))
    local bar
    bar=$(printf '%0.s#' $(seq 1 $hashes))
    bar+=$(printf '%0.s.' $(seq 1 $dots))
    echo -ne "[$bar] $percent% ($count/$total) OK:$success ERR:$fail\r"
}

while (( count < total )); do
    batch=("${files[@]:count:batch_size}")
    output=$(python pas2cs.py "${batch[@]}" 2>>"$log_file")
    last_line=$(echo "$output" | tail -n 1)
    if [[ $last_line =~ ok=([0-9]+),[[:space:]]errors=([0-9]+) ]]; then
        success=$(( success + BASH_REMATCH[1] ))
        fail=$(( fail + BASH_REMATCH[2] ))
    fi
    count=$(( count + ${#batch[@]} ))
    draw_progress
done
echo
echo "Concluído: total=$total, ok=$success, erros=$fail"
exit $(( fail > 0 ))
