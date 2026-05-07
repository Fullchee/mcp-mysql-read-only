# mcp-mysql

A minimal, single-file MCP server that gives LLMs read-only access to a MySQL database.

Inspired by <https://github.com/benborla/mcp-server-mysql>

> ⚠️ **Security Notice**: This server only works with read-only MySQL users. Never use users with write privileges.

## What it does

- **`mysql_query` tool** — execute read-only SQL queries and get JSON results
- **Resources** — browse all tables and inspect column schemas

## Usage

### GitHub Copilot (VS Code)

Paste this into your `.vscode/mcp.json`

```json
{
  "servers": {
    "local-mysql": {
      "command": "node",
      "args": ["<path-to-mcp-servers>/packages/mcp-mysql/dist/mcp-mysql.js"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "read-only-user",
        "MYSQL_PASS": "",
        "MYSQL_DB": "universe"
      }
    }
  }
}
```

### Claude Code

Paste this in your `.mcp.json`

```json
{
  "servers": {
    "local-mysql": {
      "command": "node",
      "args": ["<path-to-mcp-servers>/packages/mcp-mysql/dist/mcp-mysql.js"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "read-only-user",
        "MYSQL_PASS": "",
        "MYSQL_DB": "universe"
      }
    }
  }
}
```

### Environment variables

| Variable         | Default     | Description                          |
| ---------------- | ----------- | ------------------------------------ |
| `MYSQL_HOST`     | `127.0.0.1` | MySQL host                           |
| `MYSQL_PORT`     | `3306`      | MySQL port                           |
| `MYSQL_USER`     | `readonly`  | MySQL user (use read-only user only) |
| `MYSQL_PASSWORD` | _(empty)_   | MySQL password                       |
| `MYSQL_DATABASE` | _(none)_    | Default database                     |

## Setup

### Automatic (recommended)

From the repo root, run:

```bash
MYSQL_HOST=localhost MYSQL_USER=readonly MYSQL_DB=mydb pnpm install-mcp
```

This installs dependencies, builds the server, and registers `local-mysql` in both Claude Code (user scope) and GitHub Copilot. Supports `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASS`, `MYSQL_DB` env vars.

### Manual

```bash
pnpm install
pnpm build
```

**Important**: Create a read-only MySQL user for this server:

```sql
CREATE USER 'readonly'@'localhost' IDENTIFIED BY 'your_password';
GRANT SELECT ON your_database.* TO 'readonly'@'localhost';
FLUSH PRIVILEGES;
```
