# m02-first-repository

## What's this about

You've got Git configured — now let's actually use it. This module walks through initializing a repo, staging files, and making commits. By the end you'll have a real project history and understand the three-area model that everything else in Git builds on.

---

## The concept

Git tracks your project across three areas:

```
Working Directory  →  Staging Area  →  Repository
   (your files)       (git add)        (git commit)
```

- **Working Directory** — where you edit files normally
- **Staging Area (Index)** — a holding area where you group related changes before saving them
- **Repository** — the permanent history of your project

You don't have to commit everything at once. Staging lets you group related changes into a single, meaningful commit even if you've touched multiple files.

### Key commands this module

| Command | What it does |
|---|---|
| `git init` | Start a new repository in the current folder |
| `git status` | Show what's changed and what's staged |
| `git add <file>` | Move a file into the staging area |
| `git add src/*` | Stage all files in a folder |
| `git commit -m "message"` | Save staged changes to history |
| `git restore --staged <file>` | Unstage a file without losing changes |

> **On commit messages:** Don't write `"fix"` or `"update"`. Write what actually changed and why. Future you will thank present you.

---

## Lab

### Activity 1: Initialize a repo and make your first commit (CLI)

Navigate to the game folder:

```bash
cd sandbox/stack-overflown
```

Initialize a new Git repository:

```bash
git init
```

Check the status — you'll see all four game files listed as untracked:

```bash
git status
```

Stage the game files:

```bash
git add index.html
git add index.js
git add patterns.js
git add style.css
```

Or stage them all at once:

```bash
git add .
```

Check status again — files should now show as `new file` under "Changes to be committed":

```bash
git status
```

Commit to history:

```bash
git commit -m "Initial commit"
```

Check status one more time — you should see "nothing to commit, working tree clean":

```bash
git status
```

### Activity 2: Make more commits (CLI or VS Code)

Create a `README.md` in the `sandbox/stack-overflown/` folder with this content:

```md
# Stack Overflown

Organize the falling blocks into the current debug pattern before the stack overflows! ⏳
```

Stage and commit it:

```bash
git add README.md
git commit -m "Start game documentation"
```

Now add a second section to `README.md`:

```md
## How to Develop

- `index.html` - the game container for playing
- `index.js` - the primary game logic
- `patterns.js` - the error patterns to match during gameplay
- `style.css` - the game formatting and styling
```

Stage and commit again:

```bash
git add README.md
git commit -m "Start developer docs"
```

You now have three commits in your history. Run `git log` to see them.

---

## Challenge

Start fresh in a new folder. Initialize a Git repo, then make at least three commits to the Stack Overflown game files — each commit should represent a distinct, logical change with a clear message. Don't stage everything at once; practice staging individual files. When you're done, run `git log --oneline` and make sure each commit message actually describes what changed.

---

## What's next

→ [m03-history](../m03-history/README.md) — explore your commit history, understand HEAD, and travel back in time.

---

**Difficulty:** 🟢 Beginner | **Est. time:** 25 min | **Skills:** `git init`, `git add`, `git commit`, `git status`
