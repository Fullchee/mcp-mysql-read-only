# MCP MySQL Monorepo

A monorepo for MCP (Model Context Protocol) tools.

## Packages

- [`mysql-read-only`](./packages/mysql-read-only) - A minimal MCP server for read-only access to MySQL databases

## Usage

To use any of the MCP servers in this monorepo, add them to your MCP client configuration (e.g., `claude_desktop_config.json` for Claude Desktop, or your Cursor/Cline configuration):

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": [
        "/<path-to>/mcp-servers/packages/<server-name>/dist/server.js"
      ],
      "env": {
        "ENV_VAR_1": "value1",
        "ENV_VAR_2": "value2"
      }
    }
  }
}
```

Alternatively, you can use a `.env` file in the package directory and omit the `env` block.

For specific configuration details, environment variables, and setup instructions, see the README in each package's directory.

## Development

## Install

Requires Node.js >= 24.0.0 and pnpm >= 10.0.0.

```bash
# Install dependencies for all packages
pnpm install
```
