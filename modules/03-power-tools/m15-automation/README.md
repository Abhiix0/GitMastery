# m15-automation

10 minutes of setup saves hours of manual work.

## What's this about

Git has a hook system that lets you run scripts at specific moments in the workflow — before a commit finalises, after a merge, before a push. Combined with aliases for the commands you type fifty times a day, you can automate the tedious parts, enforce standards automatically, and stop catching the same mistakes in code review that a script could have caught before the commit was even made.

---

## Git aliases

The quickest win in this module. Aliases are shortcuts for commands you type constantly. Set them once, use them forever.

### How to set them up

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.lg "log --graph --oneline --all --decorate"
```

After this, `git st` runs `git status`, `git co main` runs `git checkout main`, and `git lg` gives you a pretty graph of the full history.

Aliases live in your global Git config (`~/.gitconfig`). View them all:

```bash
git config --global --list | grep alias
```

### Useful aliases to set up

```bash
# Pretty log graph — you'll use this constantly
git config --global alias.lg "log --graph --oneline --all --decorate"

# Undo last commit, keep changes staged
git config --global alias.undo "reset --soft HEAD~1"

# List all your aliases
git config --global alias.aliases "config --global --list"

# Short status
git config --global alias.st status

# Quick checkout
git config --global alias.co checkout

# Create and switch to a new branch
git config --global alias.cob "checkout -b"

# Show the last commit in detail
git config --global alias.last "log -1 HEAD --stat"

# Compact diff of staged changes
git config --global alias.staged "diff --staged"
```

After setting these up, your daily workflow looks like:

```bash
git co main          # instead of: git checkout main
git cob feature/x    # instead of: git checkout -b feature/x
git st               # instead of: git status
git lg               # instead of: git log --graph --oneline --all --decorate
git undo             # instead of: git reset --soft HEAD~1
```

### Lab: set up aliases on the sandbox repo

Navigate to `sandbox/stack-overflown/` and set up at least three aliases:

```bash
cd sandbox/stack-overflown

git config --global alias.lg "log --graph --oneline --all --decorate"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.st status
```

Test them:

```bash
git lg          # should show your commit graph
git st          # should show working tree status
```

Make a commit, then undo it with `git undo`. Verify the commit is gone but the changes are still staged:

```bash
echo "// test" >> index.js
git add index.js
git commit -m "Test commit for alias demo"
git lg          # commit is there
git undo        # undo it
git lg          # commit is gone
git st          # changes are still staged
git restore --staged index.js   # clean up
```

---

## Git hooks — what they are

Hooks are shell scripts that Git runs automatically at specific points in the workflow. They live in `.git/hooks/`. When Git reaches a hook point, it looks for a script with the right name, and if it finds one that's executable, it runs it.

```bash
ls .git/hooks/
```

You'll see a list of `.sample` files — Git ships with examples for every hook. They're disabled by default (the `.sample` extension means Git ignores them). To enable one, remove the `.sample` extension and make it executable.

### The most useful hooks

| Hook | When it runs | Exit 1 aborts? | Common use |
|---|---|---|---|
| `pre-commit` | Before commit is finalised, after staging | Yes | Block bad code (console.log, debug flags, secrets) |
| `commit-msg` | After message is written, before saving | Yes | Enforce commit message format |
| `post-commit` | After commit is saved | No | Notifications, logging |
| `pre-push` | Before push sends anything to remote | Yes | Run tests, block pushes to protected branches |
| `post-merge` | After a successful merge | No | Auto-install dependencies, rebuild assets |
| `post-checkout` | After checkout or branch switch | No | Environment setup, dependency checks |

The two you'll use most: `pre-commit` and `commit-msg`.

### Important: hooks are local

`.git/hooks/` is not committed to the repo. Every developer who clones your repo starts with only the `.sample` files. This is a problem for team enforcement — covered in the "Sharing hooks" section below.

---

## Lab 1 — commit-msg hook

The most practical hook to start with. It runs after you type a commit message but before Git saves it. Exit with code `1` to reject the commit and show an error. Exit `0` to let it through.

### What we're enforcing

- Message must be at least 10 characters
- Message must be at least 2 words (no single-word commits like `"fix"` or `"update"`)

### Install the hook

Navigate to your sandbox repo:

```bash
cd sandbox/stack-overflown
```

Create the hook file:

```bash
cat > .git/hooks/commit-msg << 'HOOK'
#!/bin/bash

MSG=$(cat "$1")
LENGTH=${#MSG}
WORDS=$(echo "$MSG" | wc -w)

if [ "$LENGTH" -lt 10 ]; then
  echo "❌ Commit message too short (min 10 chars). Got: '$MSG'"
  exit 1
fi

if [ "$WORDS" -lt 2 ]; then
  echo "❌ Commit message needs at least 2 words. Got: '$MSG'"
  exit 1
fi

echo "✅ Commit message looks good."
exit 0
HOOK
```

Make it executable:

```bash
chmod +x .git/hooks/commit-msg
```

### Test it

**Bad message — too short:**

```bash
echo "// test" >> index.js
git add index.js
git commit -m "fix"
```

Expected output:
```
❌ Commit message needs at least 2 words. Got: 'fix'
```

The commit is rejected. Your staged changes are still there.

**Bad message — single word, long enough:**

```bash
git commit -m "refactoring"
```

Expected output:
```
❌ Commit message needs at least 2 words. Got: 'refactoring'
```

**Good message:**

```bash
git commit -m "Fix index.js test comment"
```

Expected output:
```
✅ Commit message looks good.
[main abc1234] Fix index.js test comment
```

Clean up:

```bash
git reset --soft HEAD~1
git restore --staged index.js
git restore index.js
```

### The lowercase debate

You could add a rule that rejects messages starting with a lowercase letter. Some teams do this to enforce the Git convention of starting messages with a capital letter and an imperative verb ("Add feature" not "added feature").

The tradeoff: it's easy to enforce mechanically but creates friction for non-native English speakers and teams that use different conventions (like Conventional Commits: `feat:`, `fix:`, `chore:`). Decide as a team before adding it.

---

## Lab 2 — pre-commit hook

The `pre-commit` hook runs before the commit message prompt. It has access to the staged files. Exit `1` to abort the commit entirely.

### What we're blocking

`console.log` statements left in JavaScript files. These are fine during development but shouldn't ship to production. Catching them at commit time is better than catching them in code review.

### Install the hook

```bash
cat > .git/hooks/pre-commit << 'HOOK'
#!/bin/bash

# Check for console.log in staged JS files
if git diff --cached --name-only | grep -q "\.js$"; then
  if git diff --cached | grep -q "console\.log"; then
    echo "⚠️  console.log found in staged JS files."
    echo "    Remove it before committing, or use --no-verify to bypass."
    echo ""
    echo "    Files with console.log:"
    git diff --cached --name-only | xargs grep -l "console\.log" 2>/dev/null | sed 's/^/    /'
    exit 1
  fi
fi

exit 0
HOOK

chmod +x .git/hooks/pre-commit
```

### Test it

**Add a console.log to index.js:**

```bash
# Add a debug line somewhere in index.js
echo 'console.log("debug: score is", score);' >> index.js
git add index.js
git commit -m "Test pre-commit hook"
```

Expected output:
```
⚠️  console.log found in staged JS files.
    Remove it before committing, or use --no-verify to bypass.

    Files with console.log:
    index.js
```

Commit blocked.

**Remove it and commit successfully:**

```bash
# Remove the console.log line (last line of the file)
git restore index.js   # discard the change entirely
git status             # clean
```

**The escape hatch:**

```bash
git commit -m "Emergency commit" --no-verify
```

`--no-verify` skips all hooks. It exists for legitimate reasons (CI environments, emergency fixes) but should be used sparingly. If your team is using `--no-verify` routinely, the hook is too aggressive.

---

## Sharing hooks with your team

The problem: `.git/hooks/` isn't committed to the repo. Every new clone starts with no hooks. You can document "run this setup script" in your README, but that relies on people actually reading it.

### Option 1: scripts/hooks/ folder + manual setup

Keep your hooks in a committed folder:

```
scripts/
  hooks/
    commit-msg
    pre-commit
    README.md   ← explains how to install
```

Document in `CONTRIBUTING.md`:

```bash
# After cloning, run:
cp scripts/hooks/* .git/hooks/
chmod +x .git/hooks/*
```

Simple. Transparent. Requires manual setup per clone.

### Option 2: core.hooksPath (the better option)

Git 2.9+ supports pointing the hooks directory at any folder:

```bash
git config core.hooksPath scripts/hooks
```

If you commit this to a `.gitconfig` file or document it in a setup script, everyone who runs it gets the hooks automatically. The hooks live in the repo, are version-controlled, and apply to everyone.

For GitMastery, we use option 2. The hooks live in `scripts/hooks/` and the setup is documented in `CONTRIBUTING.md`.

### Option 3: Husky (for Node.js projects)

If your project uses npm, [Husky](https://typicode.github.io/husky/) manages hooks as a dev dependency. Hooks install automatically on `npm install`. Worth knowing about, but overkill for a project without a Node.js build step.

---

## Challenge

No steps. One paragraph.

Set up a hooks system for the Stack Overflown game that does three things: (1) blocks commits with messages under 10 characters, (2) warns — but doesn't block — if you're committing directly to `main` (print a message, exit 0), and (3) runs automatically without any manual setup needed when a contributor clones the repo. Use `core.hooksPath` to make the hooks committable. When you're done, document the entire setup in a `HOOKS.md` file in `sandbox/stack-overflown/` — clear enough that someone who's never heard of Git hooks could follow it and have everything working in under five minutes.

---

## What's next

→ [m16-advanced](../m16-advanced/README.md) — cherry-pick, worktrees, submodules, and Git internals for when you need to go deeper than the standard workflow.

---

**Difficulty:** 🔴 Advanced | **Est. time:** 40 min | **Prerequisites:** [m02-first-repository](../../00-foundations/m02-first-repository/README.md), [m09-remotes](../../02-collaboration/m09-remotes/README.md)
