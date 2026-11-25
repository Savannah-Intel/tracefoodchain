#!/usr/bin/env bash
# Guard for .semgrep/cluster-safety.yaml (+ .semgrep/image-safety.yaml) — CA 2026-11-23, owner ruling:
# NEVER destroy/recreate the shared k3d cluster or its namespaces/volumes/CRDs without the owner's explicit
# go-ahead (scaling to 0 is allowed), and never prune images/caches by hand (only safe-image-gc.sh).
# Every non-comment line of <fixtures>/bad.sh must be flagged; nothing in the other fixtures may be.
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
root=$(git -C "$here" rev-parse --show-toplevel)
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
count() { (cd "$2" && semgrep --config "$1" --metrics=off --quiet --json . \
  | python3 -c 'import json,sys; print(len({(r["path"],r["start"]["line"]) for r in json.load(sys.stdin)["results"]}))'); }
fail=0
check() {
  local name=$1 cfg=$root/.semgrep/$1.yaml fx=$here/$1
  mkdir -p "$tmp/$name"/{bad,good}/scripts
  cp "$fx/bad.sh" "$tmp/$name/bad/scripts/"
  find "$fx" -maxdepth 1 -type f ! -name bad.sh -exec cp {} "$tmp/$name/good/scripts/" \;
  local want_bad got_bad got_good
  want_bad=$(grep -cvE '^\s*(#|$)' "$fx/bad.sh")
  got_bad=$(count "$cfg" "$tmp/$name/bad" 2>/dev/null) || got_bad=ERR
  got_good=$(count "$cfg" "$tmp/$name/good" 2>/dev/null) || got_good=ERR
  echo "$name: bad got=$got_bad want=$want_bad | good got=$got_good want=0"
  [[ "$got_bad" == "$want_bad" && "$got_good" == "0" ]] || fail=1
}
check cluster-safety
[[ -d "$here/image-safety" ]] && check image-safety
exit $fail
