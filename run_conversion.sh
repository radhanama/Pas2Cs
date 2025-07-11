#!/usr/bin/env bash
set -euo pipefail

project_dir="${1:-/workspace}"

# Função para rodar o CaseFixer
run_casefixer() {
    if [ ! -d "$project_dir" ]; then
        echo "Diretório do projeto '$project_dir' não existe." >&2
        exit 1
    fi

    echo "Iniciando OmniSharp para CaseFixer..."
    omnisharp -s "$project_dir" >/tmp/omnisharp.log 2>&1 &
    omni_pid=$!

    # Aguarda até 30s pela prontidão do OmniSharp
    for _ in {1..30}; do
        if curl -s http://localhost:2000/checkreadiness >/dev/null; then
            break
        fi
        sleep 1
    done

    echo "Executando CaseFixer em '$project_dir'..."
    dotnet /tool/casefixer/CaseFixer.dll "$project_dir" --threads "$(nproc)"

    # Encerra OmniSharp
    kill "$omni_pid" && wait "$omni_pid" 2>/dev/null || true
}

# Coleta recursivamente arquivos .pas
mapfile -d '' files < <(find "$project_dir" -type f -name '*.pas' -print0)

if [ ${#files[@]} -eq 0 ]; then
    echo "Nenhum arquivo .pas encontrado; assumindo que já foi convertido."
    run_casefixer
    echo "Case fixing concluído."
    exit 0
fi

# Transpila em lotes para minimizar overhead de startup do Python
batch_size=300
count=0
total=${#files[@]}

while (( count < total )); do
    batch=( "${files[@]:count:batch_size}" )
    python3 /tool/pas2cs.py "${batch[@]}"
    for f in "${batch[@]}"; do
        rm "$f"
        echo "Convertido: $f"
    done
    count=$(( count + ${#batch[@]} ))
done

# Depois de converter .pas → .cs, corrige maiúsculas/minúsculas nos identifiers
run_casefixer

echo "Conversão e case fixing concluídos."
