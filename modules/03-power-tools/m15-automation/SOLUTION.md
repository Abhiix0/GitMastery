# Solution — m15

> **Try the challenge yourself first.**

---

## scripts/hooks/commit-msg

```bash
#!/bin/bash
MSG=$(cat "$1")
LENGTH=${#MSG}

if [ $LENGTH -lt 10 ]; then
  echo "❌ Commit message too short (minimum 10 characters)"
  exit 1
fi

exit 0
```

---

## scripts/hooks/pre-commit

Both pre-commit checks live in one file — hooks are per event, not per check.

```bash
#!/bin/bash

# Check 1: warn if committing directly to main
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ]; then
  echo "⚠️  You're committing directly to main. Use a feature branch."
  # exits 0 — this is a warning, not a block
fi

# Check 2: block TODO: comments in staged JS files
if git diff --cached --name-only | grep -q "\.js$"; then
  if git diff --cached | grep -q "TODO:"; then
    echo "❌ TODO: comment found in staged JS. Resolve or remove it before committing."
    exit 1
  fi
fi

exit 0
```

The main branch check uses `exit 0` — it prints the warning but lets the commit proceed. The TODO check uses `exit 1` — it blocks. That's the difference between a warning and an enforcement.

---

## Make them executable

```bash
chmod +x scripts/hooks/commit-msg
chmod +x scripts/hooks/pre-commit
```

---

## HOOKS.md

```markdown
# Git Hooks

This repo uses shared git hooks stored in `scripts/hooks/`.

## What they do

**commit-msg**
Blocks commit messages shorter than 10 characters.

**pre-commit**
- Warns if you're committing directly to `main` (use a feature branch instead)
- Blocks commits that include `TODO:` comments in `.js` files

## Install

Run this once after cloning:

    git config core.hooksPath scripts/hooks

That's it. The hooks are active immediately.
```

---

## Commit it

```bash
git add scripts/hooks/ HOOKS.md
git commit -m "Add shareable hooks: commit-msg length, main branch warning, TODO block"
```

---

## One thing to know about `core.hooksPath`

It's a per-repo config, not global. Every contributor needs to run `git config core.hooksPath scripts/hooks` after cloning. You can't force it automatically — Git doesn't run arbitrary code on clone for security reasons.

The practical solution: put the install command in your README's "Getting started" section and in CONTRIBUTING.md. Some teams add a `make setup` or `npm run setup` script that runs it automatically.
