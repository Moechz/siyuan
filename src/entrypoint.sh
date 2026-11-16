#!/bin/sh
# TOS wrapper: the upstream entrypoint needs root to create users. Run the
# SiYuan kernel directly as uid 1000 with a writable HOME/workspace on /data.
set -u
set -e
mkdir -p /data
export HOME=/data
exec /opt/siyuan/kernel serve --workspace=/data --accessAuthCode="${ACCESS_AUTH_CODE:-siyuan}"
