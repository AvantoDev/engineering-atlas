#!/usr/bin/env bash
#
# publish.sh — Publish or update a section of the Engineering Atlas.
#
# The Atlas is a public GitHub Pages site served from `main` root, so a
# "section" is just a self-contained HTML file committed to this repo.
# Pushing to `main` updates the live site (URL never changes).
#
# Usage:
#   ./publish.sh                      # commit & push everything currently here
#   ./publish.sh <src.html> [slug]    # add/replace one section, then push
#
#   <src.html>  A self-contained HTML deck/page to add as a section.
#   [slug]      Served filename without extension. Default: source basename.
#               e.g.  ./publish.sh ~/decks/release.html release
#                     -> copied to release.html, live at /release.html
#
# After adding a NEW section file, remember to add a matching card to
# index.html so it shows up on the hub (see README.md → "Add a section").
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

git add -A
if git diff --cached --quiet; then
  echo "→ nothing to publish (no changes)"; exit 0
fi
git commit -q -m "Publish Engineering Atlas update${SRC:+: ${SLUG}.html}"
git push -q origin HEAD
echo "✅ Published. Live at: https://avantodev.github.io/engineering-atlas/"
