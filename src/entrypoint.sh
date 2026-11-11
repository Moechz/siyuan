#!/bin/sh
# ===========================================================================
# SiYuan entrypoint for a non-root container (TOS 7 requirement).
#
# The upstream image's /opt/siyuan/entrypoint.sh creates a user and runs
# `chown -R` over /opt/siyuan, /home/siyuan and the workspace - all of which
# need root. TOS runs every app as uid 1000, so this wrapper starts the kernel
# directly and generates a stable access code on the first start instead.
#
# The access code is printed to the container log and stored next to the notes
# (workspace/.access-code), so it survives restarts and updates.
# ===========================================================================
set -e
set -u

WORKSPACE=/siyuan/workspace
CODE_FILE="$WORKSPACE/.access-code"

mkdir -p "$WORKSPACE" 2>/dev/null || true
if ! ( : > "$WORKSPACE/.write-test" ) 2>/dev/null; then
  echo "siyuan: $WORKSPACE is not writable by uid $(id -u)" >&2
  exit 1
fi
rm -f "$WORKSPACE/.write-test"

if [ -s "$CODE_FILE" ]; then
  CODE=$(cat "$CODE_FILE")
else
  CODE=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n' | cut -c1-12)
  printf '%s\n' "$CODE" > "$CODE_FILE" 2>/dev/null || true
  chmod 600 "$CODE_FILE" 2>/dev/null || true
fi

export HOME="$WORKSPACE"
export TMPDIR=/tmp

echo "==============================================================="
echo " SiYuan access code: ${CODE}"
echo " (also stored in workspace/.access-code)"
echo "==============================================================="

exec /opt/siyuan/kernel serve --workspace="$WORKSPACE" --accessAuthCode="$CODE"
