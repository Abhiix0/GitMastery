# Challenge — m15

Set up a complete hook system for the Stack Overflown repo with three hooks:

1. **commit-msg** — blocks commits with messages under 10 characters
2. **pre-commit** — warns (but does not block) if you're committing directly to `main`
3. **pre-commit** — blocks any commit that includes a `TODO:` comment in a `.js` file

All three hooks must live in `scripts/hooks/` — not `.git/hooks/` — so contributors get them with one config command.

Document the setup in a `HOOKS.md` file at the repo root. It should tell a new contributor exactly what the hooks do and how to install them.
