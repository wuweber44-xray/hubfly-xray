#!/bin/sh
set -e
: "${UUID:?UUID env required}"
PORT="${PORT:-8080}"
# Hubfly sets WSPATH; Render-style setups use WS_PATH. Prefer WSPATH.
WS_PATH="${WSPATH:-${WS_PATH:-/ray}}"
sed -e "s|__UUID__|$UUID|g" -e "s|__WS_PATH__|$WS_PATH|g" -e "s|__PORT__|$PORT|g" \
  /usr/local/etc/xray/config.json.template > /usr/local/etc/xray/config.json
exec /usr/local/bin/xray run -config /usr/local/etc/xray/config.json
