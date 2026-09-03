#!/bin/bash
# Copyright (c) 2026 4dcitygml
# SPDX-License-Identifier: Apache-2.0
# Starts the shared 4dcitygml editing tool connected to THIS city.
# The tools release is pinned in tools-release.json (tag + asset name + SHA-256).
# Fail-closed: nothing is downloaded until the pin is filled in, and nothing is
# executed unless the downloaded archive matches the pinned SHA-256.
set -e
# Locate config file: ../ when run from install/ in the repo, ./ when run from "starter kit" (small zip with bundled config)
cd "$(dirname "$0")"
[ -f "../4dcitygml.json" ] && cd ..
export CITYGML_UPSTREAM="$(python3 -c 'import json; print(json.load(open("4dcitygml.json"))["repo"])')"

MANIFEST="tools-release.json"
[ -f "install/tools-release.json" ] && MANIFEST="install/tools-release.json"
read -r TAG ASSET SHA <<EOF
$(python3 - "$MANIFEST" <<'PY'
import json, sys
m = json.load(open(sys.argv[1]))
e = m.get("macos") or {}
print(m.get("tag") or "-", e.get("asset") or "-", e.get("sha256") or "-")
PY
)
EOF
if [ "$TAG" = "-" ] || [ "$ASSET" = "-" ] || [ "$SHA" = "-" ]; then
  echo "Distribution tools release is not yet finalized (install/tools-release.json is not filled in)." >&2
  echo "For administrators: after the first tools release, fill in tag / asset / sha256." >&2
  exit 1
fi

DEST="$HOME/Documents/citygml-tools"
APP="$DEST/citygml-hub/program/hub.py"
if [ ! -f "$APP" ]; then
  echo "Downloading the editing tool ($TAG)..."
  mkdir -p "$DEST"
  TMP_ZIP="$(mktemp "${TMPDIR:-/tmp}/citygml-hub.XXXXXX")"
  curl -fL "https://github.com/4dcitygml/tools/releases/download/$TAG/$ASSET" -o "$TMP_ZIP"
  ACTUAL="$(shasum -a 256 "$TMP_ZIP" | cut -d' ' -f1)"
  if [ "$ACTUAL" != "$SHA" ]; then
    rm -f "$TMP_ZIP"
    echo "Downloaded zip SHA-256 mismatch (expected $SHA / actual $ACTUAL). Aborting." >&2
    exit 1
  fi
  unzip -oq "$TMP_ZIP" -d "$DEST"
  rm -f "$TMP_ZIP"
fi
exec python3 "$APP"
