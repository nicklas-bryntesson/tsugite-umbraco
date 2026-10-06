#!/usr/bin/env bash
# Installs Umbraco's backoffice + testing agent skills into this repo (project-local,
# not a global Claude Code plugin). Re-run to update. Pinned to the v17 branch.
# Source: https://docs.umbraco.com/umbraco-in-ai/agent-skills/backoffice-skills
set -euo pipefail

REPO="https://github.com/umbraco/Umbraco-CMS-Backoffice-Skills.git"
BRANCH="${1:-v17/main}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone -q --depth 1 -b "$BRANCH" "$REPO" "$TMP/src"
P="$TMP/src/plugins"
mkdir -p "$ROOT/.claude/skills" "$ROOT/.claude/agents"

for d in "$P"/umbraco-backoffice-skills/skills/*/ "$P"/umbraco-testing-skills/skills/*/; do
  name="$(basename "$d")"
  rm -rf "$ROOT/.claude/skills/$name"
  cp -R "$d" "$ROOT/.claude/skills/$name"
done

# The example projects are reading material and are never installed here. Their lockfiles
# only feed Dependabot hundreds of alerts and PRs for code that never runs; package.json stays.
find "$ROOT/.claude/skills" -name package-lock.json -not -path '*/node_modules/*' -delete

# Reviewer agent used by the backoffice skills
cp "$P"/umbraco-backoffice-skills/agents/*.md "$ROOT/.claude/agents/"

# Playwright harness referenced by umbraco-mocked-backoffice
rm -rf "$ROOT/.claude/skills/umbraco-mocked-backoffice/harness"
cp -R "$P/umbraco-testing-skills/harness" "$ROOT/.claude/skills/umbraco-mocked-backoffice/harness"

COMMIT="$(git -C "$TMP/src" rev-parse --short HEAD)"
VERSION="$(grep -m1 '"version"' "$P/umbraco-backoffice-skills/.claude-plugin/plugin.json" | grep -oE '[0-9]+(\.[0-9]+)*')"
printf 'Umbraco-CMS-Backoffice-Skills %s (branch %s, commit %s)\n' "$VERSION" "$BRANCH" "$COMMIT" \
  > "$ROOT/.claude/skills/UMBRACO_SKILLS_VERSION"
echo "Installed Umbraco skills $VERSION @ $COMMIT"
