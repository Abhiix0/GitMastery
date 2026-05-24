# m09-remotes

## What's this about

Everything so far has been local — just you and your machine. Remotes are how Git connects to the outside world. This module covers the core concepts: cloning a repo, pushing your changes, and pulling in changes from others. It's the foundation of every team workflow.

---

## The concept

Git is a **distributed** version control system. Every developer has a full copy of the history. A remote is just another copy of the repo — usually hosted somewhere like GitHub — that everyone can read from and write to.

### The typical collaboration loop

1. **Clone** — copy a remote repo to your local machine
2. **Branch and develop** — work locally, commit as normal
3. **Push** — publish your branch to the remote so others can see it
4. **Pull** — bring in changes others have pushed
5. **Pull request** — ask someone to review and merge your changes into the main branch

```
Local repo  ←→  Remote repo (GitHub/GitLab/etc.)
              push / pull / fetch
```

### Key commands this module

| Command | What it does |
|---|---|
| `git clone <url>` | Copy a remote repo to your machine |
| `git remote -v` | List configured remotes |
| `git push` | Send your commits to the remote |
| `git push -u origin <branch>` | Push a new branch and set up tracking |
| `git pull` | Fetch and merge remote changes into your current branch |
| `git fetch` | Download remote changes without merging |

### `pull` vs `fetch`

- `git fetch` downloads new commits from the remote but doesn't touch your working directory. Safe to run anytime.
- `git pull` is `fetch` + `merge`. It updates your branch immediately. Fine when you know what's coming in.

---

## Lab

### Activity 1: Clone a repository

Clone the GitMastery repo (or any public repo you want to practice with):

```bash
git clone https://github.com/YOUR_USERNAME/GitMastery.git
cd GitMastery
```

Check what remotes are configured:

```bash
git remote -v
```

You'll see `origin` pointing to the URL you cloned from. `origin` is just the default name Git gives the remote you cloned from — it's not special, just a convention.

### Activity 2: Push a change

Make a small change — add a line to any file in `sandbox/stack-overflown/`. Stage and commit it:

```bash
git add sandbox/stack-overflown/index.html
git commit -m "Describe your change here"
```

Push to the remote:

```bash
git push
```

If this is a new branch that doesn't exist on the remote yet:

```bash
git push -u origin your-branch-name
```

The `-u` flag sets up tracking so future `git push` and `git pull` commands know which remote branch to use.

### Activity 3: Pull in changes

If someone else (or you from another machine) pushed changes to the remote, bring them in:

```bash
git pull
```

If you want to see what's coming before merging:

```bash
git fetch
git log HEAD..origin/main --oneline
```

This shows commits on the remote that you don't have locally yet.

---

## Challenge

Fork the GitMastery repo on GitHub (or use any repo you have access to). Clone your fork locally. Create a branch called `sandbox-update`, make a small change to one of the Stack Overflown game files in `sandbox/stack-overflown/`, commit it, and push the branch to your fork. Then check GitHub to confirm the branch and commit are visible there. Don't open a PR yet — just get comfortable with the push flow.

---

## What's next

→ [m10-workflows](../m10-workflows/README.md) — learn how teams structure their branches and coordinate work at scale.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 30 min | **Skills:** `git clone`, `git push`, `git pull`, remotes concept
