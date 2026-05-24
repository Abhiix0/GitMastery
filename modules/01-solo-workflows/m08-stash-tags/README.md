# m08-stash-tags

Three small tools that will save you constantly.

None of these are glamorous. None of them show up in tutorials about "the Git workflow." But you'll reach for all three of them on a regular basis — stash when you need to context-switch without losing work, `.gitignore` when Git starts tracking files it has no business tracking, and tags when you need to bookmark a moment in history that actually means something.

---

## git stash — pause your work without committing

You're halfway through a feature. Your code is broken — intentionally, because you're mid-refactor. Then someone pings you: "the game crashes on load, can you fix it now?"

You can't commit half-broken work to `main`. You don't want to throw away what you've done. `git stash` is the answer: it takes all your uncommitted changes, bundles them up, and sets them aside so your working directory is clean. You fix the hotfix, then pop your changes back.

### Key commands

| Command | What it does |
|---|---|
| `git stash` | Stash all tracked, uncommitted changes |
| `git stash push -m "description"` | Stash with a label so you remember what it is |
| `git stash list` | Show all stashes |
| `git stash pop` | Restore the most recent stash and remove it from the list |
| `git stash apply` | Restore the most recent stash but keep it in the list |
| `git stash drop` | Delete a stash without restoring it |
| `git stash drop stash@{2}` | Delete a specific stash by index |

### What gets stashed

By default, `git stash` captures:
- Changes to tracked files (both staged and unstaged)

It does **not** capture:
- Untracked files (new files you haven't `git add`ed yet)
- Ignored files

To include untracked files: `git stash --include-untracked`

### Mini-lab: stash, hotfix, pop

Make sure you're in `sandbox/stack-overflown/` on `main`:

```bash
cd sandbox/stack-overflown
git status
```

**Simulate mid-feature work** — open `index.js` and add a half-finished comment block at the top:

```js
// TODO: refactor scoring system
// - add combo multiplier
// - track streak
// WIP: not done yet
```

Check that Git sees the change:

```bash
git status
```

You'll see `index.js` as modified. Don't commit it — it's not ready.

**Stash it:**

```bash
git stash push -m "WIP: scoring refactor notes"
```

Check your working directory is clean:

```bash
git status
```

Check the stash list:

```bash
git stash list
```

You'll see something like `stash@{0}: On main: WIP: scoring refactor notes`.

**Fix the "hotfix"** — open `index.html` and fix a typo in the title (change `Stack Overflown` to `Stack Overflown 🧱` or any small change):

```bash
git add index.html
git commit -m "Hotfix: update game title"
```

**Restore your WIP:**

```bash
git stash pop
```

Open `index.js` — your half-finished comment block is back. Git replayed your changes on top of the hotfix commit. The stash is gone from the list.

```bash
git stash list
# (empty)
```

> **Stash conflicts:** If the hotfix touched the same lines as your stash, popping will produce a merge conflict — same markers as a regular merge. Resolve it the same way.

---

## .gitignore — tell Git to stop tracking junk

Every project generates files that should never go into version control: build artifacts, editor config, OS metadata, secrets, logs. `.gitignore` is a plain text file that tells Git to pretend those files don't exist.

### How it works

Create a file called `.gitignore` in the root of your repo. Each line is a pattern. Git checks every untracked file against these patterns and skips anything that matches.

Common patterns:

```
# Directories (trailing slash = directory only)
node_modules/
dist/
.cache/

# File extensions
*.log
*.tmp
*.map

# Specific files
.env
.DS_Store
secrets.env
Thumbs.db

# Wildcards
*.local
.env.*
```

Pattern rules:
- `*` matches anything except `/`
- `**` matches across directories
- `!` negates a pattern (un-ignore something)
- Lines starting with `#` are comments

### Mini-lab: create a .gitignore for Stack Overflown

In `sandbox/stack-overflown/`, create `.gitignore`:

```bash
# OS junk
.DS_Store
Thumbs.db

# Editor config
.vscode/
.idea/

# Dependencies (if this ever gets a build step)
node_modules/

# Secrets and environment
.env
*.env
secrets.env

# Logs
*.log
npm-debug.log*
```

Now create a fake secrets file to test it:

```bash
echo "API_KEY=super-secret-123" > secrets.env
```

Check `git status`:

```bash
git status
```

`secrets.env` should not appear. Git is ignoring it.

Commit the `.gitignore`:

```bash
git add .gitignore
git commit -m "Add .gitignore for Stack Overflown"
```

### The gotcha: already-tracked files

`.gitignore` only works on **untracked** files. If you accidentally committed a file before adding it to `.gitignore`, Git will keep tracking it — the ignore rule does nothing.

The fix:

```bash
# Remove the file from Git's index (stops tracking it) without deleting it from disk
git rm --cached secrets.env

# Now add the ignore rule and commit
echo "secrets.env" >> .gitignore
git add .gitignore
git commit -m "Stop tracking secrets.env, add to .gitignore"
```

After this, `secrets.env` stays on your disk but Git ignores it completely.

> This is one of the most common Git mistakes. Someone commits `.env` or `config/database.yml` with real credentials, then adds it to `.gitignore` and wonders why it's still showing up in the repo. `git rm --cached` is the fix.

---

## git tag — bookmark a moment in history

Commit hashes are unique but not human-readable. Tags are named pointers to specific commits — like a branch that never moves. Use them to mark releases, milestones, or any point in history you'll want to reference by name.

### Lightweight vs annotated

**Lightweight tag** — just a name pointing to a commit. No extra metadata.

```bash
git tag v1.0
```

**Annotated tag** — a full Git object with a tagger name, email, date, and message. This is what you want for releases.

```bash
git tag -a v1.0 -m "First playable release of Stack Overflown"
```

Use annotated tags for anything that matters. Use lightweight tags for quick personal bookmarks.

### Key commands

| Command | What it does |
|---|---|
| `git tag` | List all tags |
| `git tag v1.0` | Create a lightweight tag at HEAD |
| `git tag -a v1.0 -m "msg"` | Create an annotated tag at HEAD |
| `git tag -a v1.0 <commit-id>` | Tag a specific past commit |
| `git show v1.0` | Show the tag details and the commit it points to |
| `git push origin v1.0` | Push a single tag to the remote |
| `git push --tags` | Push all tags to the remote |
| `git tag --delete v1.0` | Delete a tag locally |
| `git push origin --delete v1.0` | Delete a tag on the remote |

> Tags are not pushed automatically with `git push`. You have to push them explicitly.

### Mini-lab: tag the current game state

Make sure you have a clean working tree on `main`:

```bash
git status
git log --oneline -5
```

Create an annotated tag for the current state:

```bash
git tag -a v1.0 -m "Stack Overflown v1.0 — initial playable release"
```

Verify it:

```bash
git tag
git show v1.0
```

`git show` will display the tag metadata (tagger, date, message) followed by the commit it points to.

If you have a remote configured, push the tag:

```bash
git push origin v1.0
```

Or push all tags at once:

```bash
git push --tags
```

---

## Challenge

Your dev environment keeps committing OS junk. You also have half-finished work on a scoring bug. Then: the game crashes on load.

Here's the full sequence — no step-by-step, just the goal:

1. You're mid-work on `index.js` (add some half-finished code — anything). Don't commit it.
2. Introduce a deliberate "crash" on `main` — open `index.html` and add a syntax error somewhere visible, like a stray `<div` tag without a closing `>`. Commit it as `"Add broken element (simulating crash)"`.
3. Stash your WIP with a meaningful label.
4. Fix the crash on `main` — remove the broken tag, commit the fix.
5. Tag the fixed state as `v1.1-hotfix` with an annotated tag and a message explaining what was fixed.
6. Restore your WIP from the stash.
7. Create a `.gitignore` that would prevent `.DS_Store` and `*.log` files from ever being committed.

When you're done: `git log --oneline` should show the hotfix commit, `git tag` should show `v1.1-hotfix`, `git stash list` should be empty, and `.gitignore` should exist in the repo.

---

## What's next

→ [m09-remotes](../../02-collaboration/m09-remotes/README.md) — take everything you've built locally and connect it to the outside world.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 25 min | **Prerequisites:** [m02-first-repository](../../00-foundations/m02-first-repository/README.md)
