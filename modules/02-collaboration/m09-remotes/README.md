# m09-remotes

Git alone is cool. Git with remotes is how real work gets done.

Everything up to this point has been local — just you, your machine, and your history. Remotes are how Git connects copies of a repo across machines and teams. Once you understand the mental model, the commands make immediate sense. Without it, `push` and `pull` feel like magic incantations.

---

## The mental model

Here's the thing most tutorials get wrong: **the remote is not the source of truth.** It's just another copy of the repo — one that happens to live somewhere everyone can reach.

```
Your machine                     GitHub (or any host)
─────────────────                ─────────────────────
  local repo          push →       remote repo
  (full history)      ← pull       (full history)

Teammate's machine
─────────────────
  local repo          push →       same remote repo
  (full history)      ← pull
```

Every developer has a complete copy of the entire history. The remote is a shared meeting point — a place to exchange commits. If GitHub went down right now, every developer with a local clone still has the full project history. Nothing is lost.

This is what "distributed" means. It's not just a buzzword.

### What is `origin`?

`origin` is just the default name Git gives to the remote you cloned from, or the first remote you add manually. It's not special — you can rename it, delete it, or have multiple remotes with different names. `origin` is convention, not magic.

---

## Core commands

### Setting up a remote

```bash
# Add a remote called "origin" pointing to a URL
git remote add origin https://github.com/YOUR_USERNAME/your-repo.git

# List all configured remotes (and their URLs)
git remote -v
```

### Pushing and pulling

```bash
# Push your local main branch to origin
git push origin main

# Push a new branch and set up tracking (-u = --set-upstream)
git push -u origin feature/my-branch

# Pull changes from origin into your current branch
git pull origin main
```

After using `-u` once, you can just run `git push` and `git pull` with no arguments — Git knows where to send and receive.

### Cloning

```bash
# Copy a remote repo to your local machine
git clone https://github.com/OWNER/repo.git

# Clone into a specific folder name
git clone https://github.com/OWNER/repo.git my-folder
```

Cloning automatically sets up `origin` pointing to the URL you cloned from.

---

## fetch vs pull — the one that confuses everyone

This trips up almost everyone at some point. Here's the clear version:

**`git fetch`** — downloads new commits from the remote into your local repo, but does **not** touch your working directory or current branch. Your files stay exactly as they are. The remote changes land in `origin/main` (a remote-tracking branch) where you can inspect them before doing anything.

**`git pull`** — does `git fetch` + `git merge` in one step. It downloads the remote changes and immediately merges them into your current branch.

```
git fetch:   remote → origin/main (safe, read-only)
git pull:    remote → origin/main → your branch (fetch + merge)
```

**When to use which:**

Use `git fetch` when you want to see what's changed before committing to a merge:

```bash
git fetch origin

# See what's on the remote that you don't have yet
git log HEAD..origin/main --oneline

# See the actual diff
git diff HEAD origin/main

# Now merge when you're ready
git merge origin/main
```

Use `git pull` when you trust what's coming in and just want to stay up to date — like at the start of a work session on a branch only you're using.

The practical rule: `fetch` first on shared branches. `pull` is fine on your own branches.

---

## Lab 1 — Connect your sandbox to GitHub

You'll push the Stack Overflown game to a real GitHub repo.

### Step 1: Create a GitHub repo

1. Go to [github.com/new](https://github.com/new)
2. Name it `stack-overflown` (or anything you like)
3. Set it to Public or Private — your call
4. **Do not** initialize with a README, .gitignore, or license — you want an empty repo so there's no conflict with your local history

Click **Create repository**. GitHub will show you a page with setup instructions — you won't need them, but copy the repo URL.

### Step 2: Add the remote

In `sandbox/stack-overflown/`:

```bash
cd sandbox/stack-overflown
git remote -v
```

If there's no remote yet, add one:

```bash
git remote add origin https://github.com/YOUR_USERNAME/stack-overflown.git
```

Verify:

```bash
git remote -v
```

You should see `origin` listed twice — once for fetch, once for push.

### Step 3: Push

```bash
git push -u origin main
```

The `-u` flag sets up tracking. After this, `git push` with no arguments will know to push `main` to `origin`.

Go to your GitHub repo in the browser — you should see all your game files there.

### Step 4: Verify the connection

```bash
# Check that your local branch is tracking the remote
git branch -vv
```

You'll see something like `* main  abc1234 [origin/main] Your last commit message`. The `[origin/main]` part confirms tracking is set up.

---

## Lab 2 — Simulate a teammate

You'll simulate someone else pushing a change to the remote, then fetch and inspect it before merging.

### Step 1: Make a change on GitHub

1. Open your `stack-overflown` repo on GitHub
2. Click on `index.html`
3. Click the pencil icon (Edit this file)
4. Make a small change — add an HTML comment anywhere:
   ```html
   <!-- Updated via GitHub web editor -->
   ```
5. Scroll down, write a commit message like `"Add comment via web editor"`, and click **Commit changes**

The remote now has a commit your local repo doesn't know about yet.

### Step 2: Fetch and inspect

Back in your terminal:

```bash
git fetch origin
```

Git downloads the new commit but doesn't touch your files. Check what came in:

```bash
git log HEAD..origin/main --oneline
```

You'll see the commit from GitHub listed there. Your local `HEAD` hasn't moved.

See the actual diff:

```bash
git diff HEAD origin/main
```

You can read exactly what changed before merging a single byte into your working directory.

### Step 3: Merge it in

```bash
git merge origin/main
```

Or equivalently, now that you've seen what's coming:

```bash
git pull origin main
```

Check the log:

```bash
git log --oneline -5
```

The GitHub commit is now in your local history.

---

## Lab 3 — Fork workflow

Forking is how you contribute to repos you don't have write access to. You get your own copy of the repo under your GitHub account, make changes there, then open a pull request to propose merging your changes back into the original.

### Step 1: Fork the GitMastery repo

1. Go to the GitMastery repo on GitHub
2. Click **Fork** (top right)
3. GitHub creates a copy at `YOUR_USERNAME/GitMastery`

### Step 2: Clone your fork

```bash
git clone https://github.com/YOUR_USERNAME/GitMastery.git
cd GitMastery
```

Check the remotes:

```bash
git remote -v
```

You'll see `origin` pointing to your fork. It's common to also add the original repo as `upstream` so you can pull in future updates:

```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/GitMastery.git
git remote -v
```

Now you have two remotes: `origin` (your fork) and `upstream` (the original).

### Step 3: Make a change and push to your fork

Create a branch:

```bash
git checkout -b fix/readme-typo
```

Make a small change to any file — fix a typo, add a line to a README. Then:

```bash
git add .
git commit -m "Fix typo in README"
git push -u origin fix/readme-typo
```

Your change is now on your fork. From here you could open a pull request to propose merging it into the original repo — that's covered in [m11-pull-requests](../m11-pull-requests/README.md).

### Keeping your fork up to date

When the original repo gets new commits, pull them into your fork:

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

This keeps your fork's `main` in sync with the original without touching your feature branches.

---

## Challenge

No steps. Here's the scenario:

Push the Stack Overflown game to a new GitHub repo (or use the one from Lab 1). Then:

1. Make a change directly on GitHub — edit any line in `index.html` using the web editor and commit it.
2. Pull that change locally without conflicts. Confirm it's in your `git log`.
3. Now create a conflict: edit the **same line** in `index.html` locally and commit it. Then try to pull from GitHub again.
4. You'll hit a merge conflict. Resolve it — keep whichever version makes more sense, or blend both. Commit the resolution.
5. Push the resolved state back to GitHub.

When you're done: your GitHub repo and local repo should be in sync, `git log --graph --oneline` should show the conflict resolution commit, and there should be no conflict markers anywhere in `index.html`.

---

## What's next

→ [m10-workflows](../m10-workflows/README.md) — how teams structure their branches and coordinate work at scale.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 40 min | **Prerequisites:** [m02-first-repository](../../00-foundations/m02-first-repository/README.md), [m05-branching](../../01-solo-workflows/m05-branching/README.md)
