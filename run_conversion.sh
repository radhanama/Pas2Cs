#!/usr/bin/env bash
set -euo pipefail

project_dir="${1:-/workspace}"

# Collect .pas files recursively
mapfile -d '' files < <(find "$project_dir" -type f -name '*.pas' -print0)
if [ ${#files[@]} -eq 0 ]; then
    echo "No Pascal files found." >&2
    exit 0
fi

# Transpile each file to C# next to the original
for file in "${files[@]}"; do
    python3 /tool/pas2cs.py "$file"
    rm "$file"
    echo "Converted ${file}"
done

# Fix identifier casing using CaseFixer
# Start a temporary OmniSharp instance listening on port 2000
if [ -d "$project_dir" ]; then
    omnisharp -s "$project_dir" >/tmp/omnisharp.log 2>&1 &
    omni_pid=$!
    for _ in {1..30}; do
        if curl -s http://localhost:2000/checkreadiness >/dev/null; then
            break
        fi
        sleep 1
    done
    dotnet /tool/casefixer/CaseFixer.dll "$project_dir" --threads $(nproc)
    kill "$omni_pid" && wait "$omni_pid" 2>/dev/null || true
fi

echo "Conversion completed."
