# Repository Guidelines

## Project Structure & Module Organization
Root-level HTML files (`index.html`, `menu.html`, sector pages such as `nolimits.html`) form the site navigation; keep shared headers and nav markup synchronized across them. Visual assets are grouped under `bg/`, `img/`, and `foto/`, while downloadable material (ordinanze, PDFs) resides in `doc/` and `allegati/`. Styles live in `fosso.css` and `fosso2.css` alongside vendored Bootstrap files, and legacy Scriptaculous utilities sit in `js/`. Stories are written in `storie/*.html`; mirror their folder layout when adding new narratives or translations.

## Build, Test, and Development Commands
Use a lightweight server so relative asset paths stay accurate:
```bash
python3 -m http.server 4000
```
Launch it from the repo root, then browse to `http://localhost:4000/index.html`. Static linting catches most regressions before deploy:
```bash
npx htmlhint **/*.html
```
Add `--config .htmlhintrc` once you extend the rule set. Visual review remains essential; reload after editing CSS so cached files refresh.

## Coding Style & Naming Conventions
HTML and CSS follow two-space indentation, lowercase tags/attributes, and descriptive Italian copy that matches the climbing terminology already published. Keep inline styles minimal—prefer additions to `fosso.css` unless a page-specific override is unavoidable. Name assets with lowercase dashed words (e.g., `baby-school-topo.jpg`) and place large media in `foto/` to avoid leaking into the root. Reuse Bootstrap utility classes for layout instead of adding bespoke floats where possible.

## Testing Guidelines
Before opening a PR, lint all HTML, confirm that each navbar link resolves, and manually tab through dropdowns to ensure Bootstrap’s JS still behaves without console errors. When editing `storie`, proofread diacritics and ensure every story page loads its assets via relative `/fossoraibano/...` paths. Keep screenshots of layout-sensitive changes—especially hero images or warning banners—to compare desktop and mobile breakpoints.

## Commit & Pull Request Guidelines
Existing history favors short, lowercase subjects (`bootstrao`, `refactor`); continue that style, using the imperative mood when possible (e.g., `update belvedere topo`). Each pull request should describe the affected pages, include before/after screenshots for visual tweaks, and link any forum or issue threads discussing the change. Note required manual steps (optimizing new photos, translating copy) so reviewers can reproduce the result quickly.

## Asset & Content Tips
Compress JPEGs before adding them to `foto/` (target <500 KB) and credit sources inside the relevant HTML section. For regulatory documents dropped in `doc/`, preserve the original file name and add a short summary line near the download link so readers know why it matters.
