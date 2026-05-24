# m03-history

## What's this about

You've been making commits — now let's actually look at them. This module covers reading your project history, understanding what HEAD means, and using `git checkout` to move around in time. It's less scary than it sounds.

---

## The concept

Every commit in Git is a snapshot. Git links them into a chain, each one pointing back to its parent:

```
9c6ef8a  Initial commit
    ↓
16ac970  Start game documentation
    ↓
762ac02  Start developer docs   ← HEAD
```

**HEAD** is just a pointer to wherever you currently are in the history. Usually it points to the tip of your current branch. When you check out an older commit, HEAD moves there — that's called a "detached HEAD" state, which sounds alarming but just means you're looking at an old snapshot.

### Key commands this module

| Command | What it does |
|---|---|
| `git log` | Full commit history with details |
| `git log --oneline` | One commit per line, compact view |
| `git log --graph --oneline` | Visual branch diagram |
| `git log --all --graph --oneline` | Same, but includes all branches |
| `git checkout <commit-id>` | Move HEAD to a specific commit |
| `git checkout main` | Return to the latest commit on main |

---

## Lab

### Activity 1: Explore history in the CLI

Make sure you're in your `sandbox/stack-overflown/` repo with at least a few commits from m02.

Show the full history:

```bash
git log
```

Each entry shows the commit hash, author, date, and message. Press `q` to exit if it fills the screen.

Compact view — one line per commit:

```bash
git log --oneline
```

Visual graph (more useful once you have branches):

```bash
git log --graph --oneline
```

### Activity 2: Travel back in time

Copy the commit ID of your `Initial commit` from `git log --oneline`.

Check it out:

```bash
git checkout <commit-id>
```

Git will warn you about "detached HEAD" — that's fine. Look at your files. Notice that `README.md` is gone because it didn't exist at that point in history.

Come back to the present:

```bash
git checkout main
```

`README.md` is back. You didn't lose anything — you just moved your view.

### Activity 3: Explore history in VS Code

1. Open the **Source Control** tab in the left sidebar.
2. Right-click the **Changes** header and enable **Graph**.
3. The Graph panel shows your commit timeline. Click any commit to see which files it changed.

This is the same information as `git log`, just presented visually.

---

## Challenge

In your `sandbox/stack-overflown/` repo, make a small change to `patterns.js` — add a comment or tweak a pattern value — and commit it. Then use `git log --oneline` to find the commit ID of your very first commit and check it out. Confirm the change you just made is gone (because it didn't exist then). Navigate back to `main` and confirm it's back. Do all of this without looking at the lab steps.

---

## What's next

→ [m04-diffs](../m04-diffs/README.md) — see exactly what changed between commits before you save anything.

---

**Difficulty:** 🟢 Beginner | **Est. time:** 20 min | **Skills:** `git log`, `git checkout`, `HEAD`
