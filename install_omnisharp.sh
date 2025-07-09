#!/usr/bin/env bash
# Fetch OmniSharp HTTP server (net6.0) and unpack into ~/.omnisharp
set -e
VERSION="${VERSION:-v1.39.13}"
DEST="$HOME/.omnisharp"
mkdir -p "$DEST"
URL="https://github.com/OmniSharp/omnisharp-roslyn/releases/download/$VERSION/omnisharp.http-linux-x64-net6.0.tar.gz"

curl -L "$URL" -o "$DEST/omnisharp.tar.gz"
tar -xzf "$DEST/omnisharp.tar.gz" -C "$DEST"
rm "$DEST/omnisharp.tar.gz"

cat <<EOM
OmniSharp installed to $DEST.
Start the server with:
  $DEST/OmniSharp -s <path>
EOM
