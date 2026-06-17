# 🧭 Engineering Atlas

An explorable, **visual hub for how AvantoDev engineering works** — processes, architecture, and workflows, one interactive section at a time. Built for PMs, architects, developers, QA and DevOps alike.

**Live site:** https://avantodev.github.io/engineering-atlas/

This is a zero-dependency static site: every page is a single self-contained HTML file (inline CSS/JS, no build step). GitHub Pages serves `main` at the repo root.

---

## Structure

```
index.html            ← the hub landing page (grid of section cards)
jira-workflow.html     ← Section 01 · How We Work in Jira (Strata ST board)
publish.sh             ← commit + push helper (updates the live site)
.nojekyll              ← serve files as-is (no Jekyll processing)
```

Each **section** is its own self-contained HTML file at the repo root, linked from a card on `index.html`. Sections share the same visual language: dark "blueprint" canvas, blue→amber accents, Bricolage Grotesque + JetBrains Mono.

---

## Publish an update

```bash
./publish.sh
```

`main` is protected by an org ruleset (changes require a **Pull Request** + the **PR Security Pipeline** check), so `publish.sh` never pushes to `main` directly — it creates a short-lived branch, opens a **PR** (reviewer: `agile-cmejia`), and prints its URL. **Merge it once the required checks pass** and the live site updates. The URL never changes.

## Add a new section

1. Build a self-contained HTML deck/page (the [`frontend-slides`](https://github.com/zarazhangrui/frontend-slides) skill is how the existing decks were made).
2. Drop it in as a section and push:
   ```bash
   ./publish.sh ~/path/to/your-deck.html release-process
   # → copied to release-process.html, live at /release-process.html
   ```
3. Add a matching **card** to `index.html` so it appears on the hub. Copy an existing `<a class="card live …>` block, point `href` to your new file, give it a number, title, blurb, and an accent class (`k-*`). Flip a `soon` placeholder to `live` if you're filling one in.
4. Run `./publish.sh` again.

> Decks include a `⌂` home button (bottom control bar) that links back to `index.html`.

---

## Roadmap (placeholder cards on the hub)

| # | Section | Status |
|---|---------|--------|
| 01 | How We Work in Jira | ✅ Live |
| 02 | Architecture Rules (AR-01…AR-05) | 🔜 Planned |
| 03 | Release & Branching | 🔜 Planned |
| 04 | The Agent Swarm | 🔜 Planned |
| 05 | Beadbox & Initech | 🔜 Planned |
| 06 | QA & Testing | 🔜 Planned |

---

*Maintained by the AvantoDev Engineering team.*
