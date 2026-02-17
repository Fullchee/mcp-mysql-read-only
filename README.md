# MCP servers Monorepo

A monorepo for MCP (Model Context Protocol) tools.

## Packages

- [`mysql-read-only`](./packages/mysql-read-only) - A minimal MCP server for read-only access to MySQL databases

## Local usage

1. Run `pnpm install`
   1. Requires Node.js >= 24.0.0 and pnpm >= 10.0.0.

Add this to your `.vscode/mcp.json` for VS Code

```json
{
  "servers": {
    "server-name": {
      "command": "node",
      "args": ["/<path-to>/mcp-servers/packages/<server-name>/dist/server.js"],
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
