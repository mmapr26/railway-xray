#!/bin/bash
# Auto-start xray on codespace start. UUID/WSPATH come from Codespaces secrets (env vars).
# If they are not set, skip quietly so the codespace still starts normally.
if [ -z "$UUID" ] || [ -z "$WSPATH" ]; then
  echo "UUID/WSPATH not set; skipping xray start"
  exit 0
fi
export PORT="${PORT:-8080}"
pkill -f "xray run -config" 2>/dev/null || true
if ! command -v unzip >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  sudo apt-get update -y && sudo apt-get install -y unzip curl
fi
if [ ! -x /tmp/xray ]; then
  curl -sL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && unzip -o /tmp/xray.zip xray -d /tmp >/dev/null && chmod +x /tmp/xray
fi
sed -e "s|\${PORT}|$PORT|g" -e "s|\${UUID}|$UUID|g" -e "s|\${WSPATH}|$WSPATH|g" config.json.template > /tmp/config.json
nohup /tmp/xray run -config /tmp/config.json > /tmp/xray.log 2>&1 &
echo "xray started on port $PORT"
