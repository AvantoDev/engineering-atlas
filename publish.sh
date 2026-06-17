#!/usr/bin/env bash
#
# publish.sh — publish or update a section of the Engineering Atlas via a PR to main.
#
# `main` is protected by an org ruleset (changes require a Pull Request + the
# "PR Security Pipeline" workflow), so we NEVER push to main directly. This script
# creates a short-lived branch, opens a PR, and prints its URL. Merge it once the
# required checks pass — the live site updates on merge. URL never changes.
#
# Usage:
#   ./publish.sh                      # PR everything currently changed here
#   ./publish.sh <src.html> [slug]    # add/replace one section, then PR
#
#   <src.html>  A self-contained HTML deck/page to add as a section.
#   [slug]      Served filename without extension. Default: source basename.
#
# After adding a NEW section file, also add a matching card to index.html (see README).
#
set -euo pipefail
cd "$(dirname "$0")"

SRC="${1:-}"
if [[ -n "$SRC" ]]; then
  [[ -f "$SRC" ]] || { echo "error: file not found: $SRC" >&2; exit 1; }
  SLUG="${2:-$(basename "$SRC" .html)}"
  cp "$SRC" "./${SLUG}.html"
  echo "→ added section: ${SLUG}.html"
fi

# Always branch off the latest main — never commit straight to it.
git checkout main >/dev/null 2>&1
git pull --ff-only --quiet origin main || true
BR="atlas/update-$(date +%Y%m%d-%H%M%S)"
git checkout -b "$BR"

git add -A
if git diff --cached --quiet; then
  echo "→ nothing to publish (no changes)"; git checkout main >/dev/null 2>&1; exit 0
fi
git commit -q -m "Publish Engineering Atlas update${SRC:+: ${SLUG}.html}"
git push -q -u origin "$BR"

# Open the PR (Leonardo is the author → request review from Christian).
gh pr create --base main --head "$BR" \
  --title "Publish Atlas update${SRC:+: ${SLUG}.html}" \
  --body $'Automated Engineering Atlas publish.\n\n🤖 Generated with Claude Code' \
  --reviewer agile-cmejia

echo "✅ PR opened. Once the security pipeline passes and it merges →"
echo "   live at https://avantodev.github.io/engineering-atlas/"
