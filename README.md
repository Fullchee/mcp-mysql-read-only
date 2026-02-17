# mcp-server-mysql-minimal

A minimal, single-file MCP server that gives LLMs access to a MySQL database.

## What it does

- **`mysql_query` tool** — execute any SQL and get JSON results
- **Resources** — browse all tables and inspect column schemas

## Setup

```bash
pnpm install          # or npm install
cp .env.example .env  # edit with your MySQL credentials
pnpm build
```

## Usage

### With Claude Desktop / Cursor / any MCP client

Add to your MCP config (e.g. `claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "mysql": {
      "command": "node",
      "args": ["/absolute/path/to/mcp-server-mysql-minimal/dist/server.js"],
      "env": {
        "MYSQL_HOST": "127.0.0.1",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "root",
        "MYSQL_PASSWORD": "",
        "MYSQL_DATABASE": "mydb"
      }
    }
  }
}
```

Or if you have a `.env` file in the project directory, you can omit the `env` block.

### Environment variables

| Variable         | Default     | Description          |
| ---------------- | ----------- | -------------------- |
| `MYSQL_HOST`     | `127.0.0.1` | MySQL host          |
| `MYSQL_PORT`     | `3306`      | MySQL port           |
| `MYSQL_USER`     | `root`      | MySQL user           |
| `MYSQL_PASSWORD` | *(empty)*   | MySQL password       |
| `MYSQL_DATABASE` | *(none)*    | Default database     |

## Project structure

```
server.ts        ← the entire server (~130 lines)
package.json
tsconfig.json
.env.example
```
