#!/usr/bin/env bash
# batch_transpile.sh - run pas2cs.py for every .pas file under given folders
# Usage: ./batch_transpile.sh LOGFILE DIR [DIR...]
# The generated .cs is written next to each source file.
# All parse errors and TODO warnings are appended to LOGFILE.

log_file="$1"
shift || { echo "usage: $0 LOGFILE DIR [DIR...]" >&2; exit 1; }

: > "$log_file"

process_file() {
    local src="$1"
    local out="${src%.pas}.cs"
    if python pas2cs.py "$src" > "$out" 2>>"$log_file"; then
        :
    else
        echo "ERROR in $src" >>"$log_file"
    fi
}

for dir in "$@"; do
    find "$dir" -name '*.pas' -print0 | while IFS= read -r -d '' f; do
        process_file "$f"
    done
done

