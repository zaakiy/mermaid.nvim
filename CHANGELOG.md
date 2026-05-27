# Changelog

All notable changes to mermaid.nvim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Live preview browser via built-in Lua HTTP server + SSE streaming
- Dual renderer support: `mermaid.js` (official) and `beautiful-mermaid` (aesthetic)
- Built-in diagram formatter with token padding and smart indentation
- Lint integration with `mmdc` via `vim.diagnostic`
- Auto-open browser on macOS (native `open`) and Linux (`xdg-open`)
- Floating toolbar with zoom, reset, copy PNG, download SVG
- HTML template with renderer and theme injection
- Graceful server shutdown on idle (20s timeout)

### Changed
- Initial project setup and repository scaffolding

## [0.2.0] — 2026-05-15

### Added
- **Server refactoring**: Modular route handlers (`handle_sse`, `handle_root`, `handle_static`)
- **Server security**: Request timeout (10s), TCP keepalive, directory traversal protection
- **MIME type map**: Proper `Content-Type` for css/js/svg/png files
- **CI/CD**: GitHub Actions workflow (lint + test matrix v0.9–nightly + auto-release)
- **Issue templates**: Bug report + feature request markdown templates
- **`.luacheckrc`**: Lua lint configuration for CI
- **`Makefile`**: `make test` convenience target
- **Format**: `%%` comment masking (inline and standalone)
- **Format**: Single-quoted string `'...'` masking
- **Format**: `%%{init: ...}%%` directive protection
- **Format**: `-- mermaid-format-ignore` skip marker
- **Format**: Missing diagram types: `timeline`, `xychart-beta`, `sankey-beta`, `block`, `info`
- **Format**: Improved `{}` balanced-brace detection for self-closing blocks
- **Format**: Additional arrow variants: `===`, `===>`, `--->`, `-+`, `-)`
- **Format**: Full test coverage for all 10+ diagram types
- **Lint**: Multi-format error parsing (5 parse variants + warning level)
- **Lint**: ANSI escape code stripping before parsing
- **Preview**: Dark mode detection via `vim.o.background`
- **Preview**: Live theme sync on `:set background` via `OptionSet` autocmd
- **Preview**: `:MermaidPreviewStop` command
- **`CONTRIBUTING.md`**: Project structure, dev guide, commit conventions

### Fixed
- doc/mermaid.txt: `shift_width` documented as 2 (was actually 4 by default)
- format: `is_start_block` missing new diagram keywords
- format: `%%` inside `%%{init}%%` being treated as comments
- server: `stop_server()` not closing SSE clients properly
- server: No `Content-Type` mapping for CSS/JS files

### Added (tests)
- `tests/format_all_spec.lua` — 10 diagram types, ~20 test cases
- `tests/format_edge_spec.lua` — %% comments, ignore marker, braces, 5+ edge cases
- `tests/lint_spec.lua` — 5 error formats, ANSI cleaning, severity mapping
- `tests/server_spec.lua` — startup/shutdown, SSE broadcast, HTML template, theme mode

## [0.3.0] — 2026-05-15

### Added
- **SSE exponential backoff**: Retry with 1s→2s→4s→…→30s cap
- **Connection status indicator**: Top-right live status (● connected / ◌ reconnecting / ○ disconnected)
- **Structured error display**: Frontend error container with detailed messages
- **Floating panel** (`lua/mermaid/panel.lua`): In-editor control window with URL, status, renderer
- **Terminal inline render** (`lua/mermaid/render.lua`):
  - Kitty protocol (`kitty +kitten icat`): Full-color SVG rendering
  - chafa support: ASCII/ANSI art conversion
  - Auto-detection of terminal capabilities
- **`:MermaidRender`** command: Render diagram inline in terminal
- **`:MermaidCopyURL`** command: Copy preview URL to clipboard
- **`docs/`** directory: GitHub Pages landing page (Catppuccin Mocha theme)
- **`examples/`** directory: 9 example `.mmd` files covering all diagram types
- **`CHANGELOG.md`**: Formal changelog with Keep a Changelog format

### Changed
- `preview.lua`: Opens floating panel on `:MermaidPreview`
- `plugin/mermaid.lua`: `:MermaidPreviewStop` closes panel
- `static/css/preview.css`: Connection status + error container z-index layers
- `static/index.html`: Rewritten SSE module with proper lifecycle management
- `README.md`: Full rewrite with FAQ, Troubleshooting, badges, roadmap, config guide

### Added (tests)
- `tests/panel_spec.lua` — 6 tests (open/close, update, auto-refresh)
- `tests/render_spec.lua` — 6 tests (capability detection, SVG gen, error handling)
- Total test count: 9 spec files, 55+ test cases

---

Template for future releases:

## [0.X.0] — YYYY-MM-DD

### Added
- 

### Changed
- 

### Fixed
- 

### Removed
- 
