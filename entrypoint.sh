#!/bin/sh
set -e
: "${PORT:=8080}"
: "${UUID:?UUID env required}"
: "${WSPATH:=/ws}"
sed -e "s|\${PORT}|$PORT|g" -e "s|\${UUID}|$UUID|g" -e "s|\${WSPATH}|$WSPATH|g" /config.json.template > /config.json
exec /usr/local/bin/xray run -config /config.json
