#!/bin/sh
# ===========================================================================
# SiYuan entrypoint for a non-root container (TOS 7 requirement).
#
# The upstream image's /opt/siyuan/entrypoint.sh creates a user and runs
# `chown -R` over /opt/siyuan, /home/siyuan and the workspace, which needs
# root. TOS runs the application as uid 1000, so this wrapper starts the
# kernel directly and keeps the workspace on the mounted data folder.
#
# Access code (S6/F10): never hard-coded and never written to the log.
#   1. ACCESS_AUTH_CODE in the container environment wins (user supplied).
#   2. Otherwise a random code is generated once and kept in
#      <workspace>/.access-code with mode 0600, so it survives restarts and
#      upgrades without ever appearing in `docker logs` or `docker inspect`.
# The code is handed to the kernel through SIYUAN_ACCESS_AUTH_CODE (the
# kernel's own environment variable), not through argv.
# ===========================================================================
set -u
set -e

WORKSPACE=/data
CODE_FILE="${WORKSPACE}/.access-code"

umask 077
mkdir -p "${WORKSPACE}"

if ! ( : > "${WORKSPACE}/.write-test" ) 2>/dev/null; then
    echo "siyuan: ${WORKSPACE} is not writable by uid $(id -u)" >&2
    echo "siyuan: the application data folder must be owned by 1000:1000" >&2
    exit 1
fi
rm -f "${WORKSPACE}/.write-test"

if [ -n "${ACCESS_AUTH_CODE:-}" ]; then
    CODE="${ACCESS_AUTH_CODE}"
elif [ -s "${CODE_FILE}" ]; then
    CODE="$(cat "${CODE_FILE}")"
else
    CODE="$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n' | cut -c1-12)"
    printf '%s\n' "${CODE}" > "${CODE_FILE}"
    chmod 600 "${CODE_FILE}" 2>/dev/null || true
fi

export SIYUAN_ACCESS_AUTH_CODE="${CODE}"
export HOME="${WORKSPACE}"
export TMPDIR=/tmp

exec /opt/siyuan/kernel serve --workspace="${WORKSPACE}"
