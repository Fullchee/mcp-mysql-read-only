#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVER_PATH="$REPO_ROOT/packages/mcp-mysql/dist/mcp-mysql.js"

npm install -g corepack@latest
corepack enable
cd "$REPO_ROOT"
pnpm install
pnpm build

HOST="${MYSQL_HOST:-localhost}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_USER:-readonly}"
PASS="${MYSQL_PASS:-}"
DB="${MYSQL_DB:-}"

# Claude Code (user scope)
if ! claude mcp get local-mysql -s user >/dev/null 2>&1; then
    claude mcp add -s user local-mysql \
        node "$SERVER_PATH" \
        -e MYSQL_HOST="$HOST" \
        -e MYSQL_PORT="$PORT" \
        -e MYSQL_USER="$USER" \
        -e "MYSQL_PASS=$PASS" \
        -e MYSQL_DB="$DB"
fi

# GitHub Copilot (user scope)
MCP_JSON="$HOME/Library/Application Support/Code/User/mcp.json"
if [[ -f "$MCP_JSON" ]]; then
    tmp=$(mktemp)
    jq --arg path "$SERVER_PATH" \
       --arg host "$HOST" --arg port "$PORT" \
       --arg user "$USER" --arg pass "$PASS" --arg db "$DB" '
      if .servers["local-mysql"] then .
      else .servers["local-mysql"] = {
        "type": "stdio",
        "command": "node",
        "args": [$path],
        "env": {
          "MYSQL_HOST": $host,
          "MYSQL_PORT": $port,
          "MYSQL_USER": $user,
          "MYSQL_PASS": $pass,
          "MYSQL_DB": $db
        }
      } end
    ' "$MCP_JSON" > "$tmp" && mv "$tmp" "$MCP_JSON"
else
    echo "Warning: $MCP_JSON not found, skipping GitHub Copilot MCP setup."
fi

echo "Done. Updated files:"
echo "  $MCP_JSON"
echo "  ~/.claude.json"
echo "Start a new session with Claude and VS Code to use the local-mysql server."
