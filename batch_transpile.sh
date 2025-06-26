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

# processa todos os arquivos em uma única chamada ao Python
python pas2cs.py "${files[@]}" 2>>"$log_file"

# imprime resumo simples
if grep -q '^ERROR' "$log_file"; then
    erros=$(grep -c '^ERROR' "$log_file")
    ok=$(( total - erros ))
else
    erros=0
    ok=$total
fi
echo "Concluído: total=$total, ok=$ok, erros=$erros"
