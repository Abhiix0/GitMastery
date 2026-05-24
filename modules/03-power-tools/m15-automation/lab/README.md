# Lab — Hooks and aliases

**Working directory:** `sandbox/stack-overflown/`

---

## Part 1 — Aliases

Set these up globally:

```bash
git config --global alias.st "status"
git config --global alias.lg "log --graph --oneline --all --decorate"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.aliases "config --global --list"
```

Test them:
```bash
git st
git lg
git aliases
```

`git undo` undoes the last commit but keeps the changes staged — useful when you committed too early or with the wrong message. Don't run it now unless you have a commit to undo.

Aliases live in `~/.gitconfig`. You can edit them directly there if you prefer.

---

## Part 2 — commit-msg hook

This hook runs after you type a commit message but before the commit is saved. Exit non-zero to abort.

**1. Create the hook file:**
```bash
# path: .git/hooks/commit-msg
```

Contents:
```bash
#!/bin/bash
MSG=$(cat "$1")
LENGTH=${#MSG}
WORDS=$(echo "$MSG" | wc -w)

if [ $LENGTH -lt 10 ]; then
  echo "❌ Commit message too short (minimum 10 characters)"
  exit 1
fi

if [ $WORDS -lt 2 ]; then
  echo "❌ Commit message needs at least 2 words"
  exit 1
fi

echo "✅ Good commit message"
exit 0
```

**2. Make it executable:**
```bash
chmod +x .git/hooks/commit-msg
```

**3. Test with a bad message:**
```bash
# stage any change first
git add .
git commit -m "fix"
```
Should be blocked.

**4. Test with a good message:**
```bash
git commit -m "Fix score display showing NaN"
```
Should pass.

---

## Part 3 — pre-commit hook

This hook runs before the commit message prompt. Use it to check what's being staged.

**1. Create the hook file:**
```bash
# path: .git/hooks/pre-commit
```

Contents:
```bash
#!/bin/bash
if git diff --cached --name-only | grep -q "\.js$"; then
  if git diff --cached | grep -q "console\.log"; then
    echo "⚠️  console.log found in staged JS. Remove it before committing."
    exit 1
  fi
fi
exit 0
```

**2. Make it executable:**
```bash
chmod +x .git/hooks/pre-commit
```

**3. Test the block:**
```bash
# add console.log("debug") somewhere in index.js
git add index.js
git commit -m "Test commit with console log"
```
Should be blocked.

**4. Remove the `console.log`, then commit normally** — should pass.

---

## Part 4 — Shareable hooks

Hooks in `.git/hooks/` aren't committed — `.git/` is never tracked. To share hooks with your team, put them in the repo itself.

**1. Create the directory:**
```bash
mkdir -p scripts/hooks
```

**2. Copy both hooks there** and add this comment at the top of each file:
```bash
# Install: git config core.hooksPath scripts/hooks
```

**3. Commit them:**
```bash
git add scripts/hooks/
git commit -m "Add shareable git hooks"
```

**4. Activate them:**
```bash
git config core.hooksPath scripts/hooks
```

Anyone who clones the repo runs that one command and gets all the hooks. Document it in your README or CONTRIBUTING.md.

---

## Verification

`git config core.hooksPath scripts/hooks` works in a fresh clone. Both hooks fire correctly from `scripts/hooks/`.
