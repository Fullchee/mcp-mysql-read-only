# mcp-mysql

Minimal, single-file MCP server — gives LLMs read-only access to MySQL.

Inspired by <https://github.com/benborla/mcp-server-mysql>

## Why this exists

[benborla/mcp-server-mysql](https://github.com/benborla/mcp-server-mysql) is full-featured but heavy (~500+ lines across multiple modules):
- Multi-DB support
- Docker + Smithery/npx distribution
- SSH tunnel support
- Per-operation write flags
- Test suite, evals, CI
- Dozens of env vars

Overkill for local dev. This implementation prioritizes:

- **Single file** (~275 lines) — easy to audit, no surprises
- **Hard enforcement at startup** — verifies MySQL user privileges via `SHOW GRANTS`; refuses to start if write privileges detected
- **No global install** — runs from local build, no `npx` or registry required
- **One-command setup** — `pnpm install-mcp` registers in both Claude Code and GitHub Copilot

> ⚠️ **Security Notice**: Only works with read-only MySQL users. Never use users with write privileges.

## What it does

- **`mysql_query` tool** — execute read-only SQL queries, get JSON results
- **Resources** — browse all tables, inspect column schemas

## Usage

### GitHub Copilot (VS Code)

Paste into `.vscode/mcp.json`:

```json
{
  "servers": {
    "local-mysql": {
      "command": "node",
      "args": ["<path-to-mcp-servers>/packages/mcp-mysql/dist/mcp-mysql.js"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "root",
        "MYSQL_PASS": "",
        "MYSQL_DB": "universe",
        "DANGEROUSLY_ALLOW_WRITES": "true"
      }
    }
  }
}
```

### Claude Code

Via CLI:

```bash
claude mcp add mcp_server_mysql \
  -e MYSQL_HOST="127.0.0.1" \
  -e MYSQL_PORT="3306" \
  -e MYSQL_USER="root" \
  -e MYSQL_PASS="your_password" \
  -e MYSQL_DB="your_database" \
  -e ALLOW_INSERT_OPERATION="false" \
  -e ALLOW_UPDATE_OPERATION="false" \
  -e ALLOW_DELETE_OPERATION="false" \
  -- npx @citylitics/mcp-mysql
```

Or paste into `.mcp.json`:

```json
{
  "servers": {
    "local-mysql": {
      "command": "node",
      "args": ["<path-to-mcp-servers>/packages/mcp-mysql/dist/mcp-mysql.js"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "root",
        "MYSQL_PASS": "",
        "MYSQL_DB": "universe",
        "DANGEROUSLY_ALLOW_WRITES": "true"
      }
    }
  }
}
```

### Environment variables

| Variable                   | Default     | Description                                                                |
| -------------------------- | ----------- | -------------------------------------------------------------------------- |
| `MYSQL_HOST`               | `127.0.0.1` | MySQL host                                                                 |
| `MYSQL_PORT`               | `3306`      | MySQL port                                                                 |
| `MYSQL_USER`               | `readonly`  | MySQL user (use read-only user only)                                       |
| `MYSQL_PASSWORD`           | _(empty)_   | MySQL password                                                             |
| `MYSQL_DATABASE`           | _(none)_    | Default database                                                           |
| `DANGEROUSLY_ALLOW_WRITES` | _(unset)_   | Set to `"true"` to allow users with write privileges (skips safety check). |

## Setup

### Automatic (recommended)

```bash
MYSQL_HOST=localhost MYSQL_USER=readonly MYSQL_DB=mydb pnpm install-mcp
```

What this does:
- Installs dependencies
- Builds the server
- Registers `local-mysql` in both Claude Code (user scope) and GitHub Copilot

Supported env vars: `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASS`, `MYSQL_DB`

### Manual

```bash
pnpm install
pnpm build
```

Create a read-only MySQL user:

```sql
CREATE USER 'readonly'@'localhost' IDENTIFIED BY 'your_password';
GRANT SELECT ON your_database.* TO 'readonly'@'localhost';
FLUSH PRIVILEGES;
```
