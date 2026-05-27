# Contributing to mermaid.nvim 🧜

Thanks for your interest in contributing! This document outlines how to get started.

## Project Structure

```
mermaid.nvim/
├── lua/mermaid/
│   ├── init.lua      # Plugin entry point, config defaults
│   ├── format.lua    # Built-in Mermaid diagram formatter
│   ├── lint.lua      # Diagnostics via mermaid-cli
│   ├── preview.lua   # Preview orchestration (browser, autocommands)
│   └── server.lua    # Built-in Lua HTTP server with SSE
├── plugin/
│   └── mermaid.lua   # User commands (:MermaidFormat, :MermaidPreview, etc.)
├── ftdetect/
│   └── mermaid.lua   # Filetype detection (.mmd, .mermaid)
├── static/
│   ├── index.html    # Preview page template
│   ├── css/preview.css
│   └── js/preview.js # Client-side rendering + toolbar
├── tests/            # Plenary test specs
├── doc/
│   └── mermaid.txt   # Vim help file
└── .github/
    ├── workflows/    # CI configuration
    └── ISSUE_TEMPLATE/
```

## Development Setup

1. Clone the repo into your Neovim plugin path.
2. Make changes; reload with `:luafile %` or restart Neovim.
3. Run tests:

```bash
make test
# or
nvim --headless -u tests/minimal_init.lua \
  -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"
```

## Code Style

- Use 2-space indentation in Lua files.
- Follow Neovim Lua conventions (snake_case functions, PascalCase modules).
- Document public API functions with comments.
- Keep the built-in HTTP server minimal — no external dependencies.
- All new features should have corresponding tests.

## Adding a New Feature

1. Open an issue describing the feature (use the Feature Request template).
2. Fork the repo and create a feature branch off `develop`.
3. Implement with tests.
4. Update `doc/mermaid.txt` if adding/changing commands or configuration.
5. Open a PR against `develop`.

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — new feature
- `fix:` — bug fix
- `refactor:` — code restructure
- `test:` — test additions/updates
- `doc:` — documentation only
- `ci:` — CI/workflow changes

## PR Checklist

- [ ] Tests pass: `make test`
- [ ] New tests added for new behavior
- [ ] Documentation updated if applicable
- [ ] No new `vim.notify` noise in tests (mock if needed)

## Questions?

Open an issue or start a discussion — we're happy to help!
