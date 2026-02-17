# MCP MySQL Monorepo

A monorepo for MCP (Model Context Protocol) tools.

## Packages

- [`mysql-read-only`](./packages/mysql-read-only) - A minimal MCP server for read-only access to MySQL databases

## Development

```bash
# Install dependencies for all packages
pnpm install

# Build all packages
pnpm build

# Watch mode for development
pnpm watch
```

## Requirements

- Node.js >= 24.0.0
- pnpm >= 10.0.0
