# Tsugite-Umbraco — repo guide

The bearing thesis: **one Tsugite component contract renders both a
server-rendered Umbraco (Razor) component and a Vue component that behave
identically in the browser — same DOM, same gates, same refusals.**

[Tsugite](https://github.com/nicklas-bryntesson/Tsugite) (sibling checkout:
`../Tsugite`) already proves that a component contract can drive Astro, Vue
and TSX to byte-identical markup. This repo tests whether Razor can be one
more renderer of the same contract.

The starting point is AiPoc (`../../Playgrounds/Umbraco/AiPoc`), an Umbraco 17
site whose components are ASP.NET Core Tag Helpers. It shares some of
Tsugite's thinking but not its contract model. Moving it there is the work.

## Current state

Step 1 is done: a clean Umbraco 17 site with AiPoc's packages and Vite
pipeline, and no components. AiPoc's Tag Helpers are deliberately **not**
ported. Components arrive later, built on the Tsugite contract model.

## Hard rules

1. **English everywhere.** Code, comments, docs, commit messages.
2. **Tsugite is the source of truth for the component model.** Read its
   `CLAUDE.md`, `TLDR.md` and ADR ledger (`packages/tsugite/docs/adr/`)
   before designing anything component-shaped. Never reintroduce
   base-plus-override CSS, utility classes or prop combinations.
3. **`.claude/contracts/`, `.claude/patterns/` and `.claude/PRD.md` came
   from AiPoc** and describe its Tag Helper model. They are reference
   material, not rules for this repo.
4. **Git flow.** Work on branches (`feat/`, `fix/`, `chore/`, `docs/`) and
   reach `main` through pull requests. Never force-push. Stage files
   explicitly (no `git add -A` / `git add .`).

## Layout

| Path | Purpose |
|------|---------|
| `TsugiteUmbraco.slnx` | Solution |
| `src/TsugiteUmbraco.Web/` | The Umbraco site (assembly `TsugiteUmbraco`) |
| `src/TsugiteUmbraco.Web/Program.cs` | Startup: Umbraco + Vite.AspNetCore |
| `src/TsugiteUmbraco.Web/ClientApp/` | Vite + TypeScript frontend, entry `main.ts` |
| `src/TsugiteUmbraco.Web/Views/Shared/_Layout.cshtml` | Master layout, loads the Vite entry |
| `tests/` | Test projects (none yet) |
| `.claude/skills/umbraco-*` | Umbraco backoffice skills, synced by `.claude/scripts/sync-umbraco-skills.sh` |

## Stack

- Umbraco 17.7 (LTS) on .NET 10, SQLite
- Umbraco.Forms, Umbraco.AI (+ Anthropic, OpenAI, Agent, Copilot, Prompt),
  Umbraco.Automate. All pinned to the 17.x line, because 18.x needs Umbraco 18.
- Vite.AspNetCore 2.4 → Vite 8, TypeScript

## Commands

```bash
dotnet build TsugiteUmbraco.slnx
dotnet watch --project src/TsugiteUmbraco.Web   # also starts Vite (AutoRun)

cd src/TsugiteUmbraco.Web/ClientApp
npm install
npm run build        # → wwwroot/dist/ (git-ignored)
npm run typecheck
```

- Site: `https://localhost:44323`, backoffice `/umbraco`
- Vite dev server: port **5174** (not 5173, so AiPoc can run alongside).
  The port is set in both `ClientApp/vite.config.ts` and `Program.cs`.
  Keep them in sync.

## Umbraco notes

- The first run shows the Umbraco installer. Choose SQLite there. The database
  lives in `src/TsugiteUmbraco.Web/umbraco/Data/` (git-ignored). Move it only
  with Umbraco stopped.
- Umbraco.Automate logs a fatal "no such table" error before install. Restart
  once after installing, and it migrates and activates.
- The Umbraco MCP server (`.mcp.json`) reads credentials from `.env`. See
  `.env.example`. Create the OAuth client in the backoffice under
  Settings → OAuth clients.
- Updating a document does not republish it. Always publish after updates.
- Templates must exist as database entities, not just as `.cshtml` files.
