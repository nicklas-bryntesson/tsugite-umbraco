# Tsugite-Umbraco 継手

Can one [Tsugite](https://github.com/nicklas-bryntesson/Tsugite) component
contract render both a server-side Umbraco (Razor) component and a Vue
component that behave identically in the browser?

## Requirements

- .NET 10 SDK
- Node.js 22+

## Getting started

```bash
cd src/TsugiteUmbraco.Web/ClientApp && npm install && cd -
dotnet watch --project src/TsugiteUmbraco.Web
```

Open `https://localhost:44323` and complete the Umbraco installer (choose
SQLite). Restart once afterwards, so that Umbraco.Automate can migrate its
tables. Vite starts automatically on port 5174.

### MCP (optional)

Copy `.env.example` to `.env` and fill in the client secret of an OAuth
client created in the backoffice (Settings → OAuth clients).

## Build

```bash
cd src/TsugiteUmbraco.Web/ClientApp && npm run build && cd -
dotnet build TsugiteUmbraco.slnx
```
