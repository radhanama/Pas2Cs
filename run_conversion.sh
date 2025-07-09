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
# OmniSharp server is expected to be running on port 2000
if [ -d "$project_dir" ]; then
    dotnet /tool/casefixer/CaseFixer.dll "$project_dir" --threads $(nproc)
fi

echo "Conversion completed."
