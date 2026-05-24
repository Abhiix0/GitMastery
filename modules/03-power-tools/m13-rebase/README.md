# m13-rebase

Rebase is not scary — it's just moving commits. Here's the mental model.

Most people avoid rebase because they've heard it "rewrites history" and that sounds dangerous. It does rewrite history. That's the point. Once you understand what it's actually doing, the commands make complete sense and the golden rule ("never rebase shared branches") becomes obvious rather than arbitrary.

---

## The honest intro

There are two ways to integrate one branch into another:

**Merge** — takes both branch histories and ties them together with a merge commit. The history is honest: it shows exactly what happened, when, and on which branch. It can get messy in a busy repo, but nothing is hidden.

**Rebase** — takes your commits and replays them on top of another branch, as if you'd started your work from there. The history is clean and linear. But it rewrites commits — new hashes, new timestamps, new parent pointers. The original commits are gone.

Neither is always right. Teams that value traceability use merge. Teams that value a clean, readable history use rebase. Many teams use both: rebase to clean up a feature branch before it's reviewed, merge to bring it into `main`.

The important thing is knowing what each one does before you reach for it.

---

## Mental model: rebase as "replaying commits"

This is the picture to hold in your head.

**Before rebase:**

```
main:    A ── B ── C
                    \
feature:             D ── E
```

`main` has moved on (commit C was added after you branched). Your feature branch still starts from B.

**After `git rebase main` (run from the feature branch):**

```
main:    A ── B ── C
                    \
feature:             D' ── E'
```

Git took commits D and E, lifted them off their original base (B), and replayed them one by one on top of C. The result is D' and E' — same changes, new hashes, new parent pointers.

Your feature branch now looks like you started it from C, not B. The history is linear. If you merge this into `main` now, it'll be a clean fast-forward.

**What "replaying" actually means:**

Git doesn't copy commits. It takes the diff of each commit (what changed from its parent) and applies that diff to the new base. If the diff applies cleanly, you get a new commit. If it doesn't — because the new base changed the same lines — you get a conflict, right there in the middle of the rebase.

This is why D becomes D': same diff, different parent, different hash. The commit is new even if the change is identical.

---

## The golden rule

> **Never rebase a branch that other people have pulled.**

Here's what happens if you break it:

1. You and a teammate both have `feature/scoring` checked out
2. You rebase `feature/scoring` onto `main` — D and E become D' and E'
3. You force-push to the remote (you have to, because the histories diverged)
4. Your teammate still has the old D and E locally
5. When they pull, Git sees two diverged histories and tries to merge them
6. They end up with D, E, D', and E' — duplicate commits with different hashes
7. The history is now genuinely broken and someone has to clean it up manually

The rule exists because rebase creates new commits. If anyone else has the old commits, you've created a split that Git can't automatically reconcile.

**Safe to rebase:** your own local branches, feature branches only you are working on, branches you haven't pushed yet.

**Never rebase:** `main`, `develop`, any branch other people have cloned or pulled.

---

## Lab 1 — Basic rebase

You'll create a feature branch, add a commit to `main` to simulate it moving on, then rebase the feature branch onto the updated `main`.

### Setup

```bash
cd sandbox/stack-overflown
git checkout main
git log --oneline -3
```

### Step 1: Create a feature branch and make two commits

```bash
git checkout -b feature/rebase-practice
```

Open `index.js`. Add a comment above `moveLeft`:

```js
// Move the current piece one column to the left
function moveLeft() {
```

```bash
git add index.js
git commit -m "Add comment above moveLeft"
```

Add a comment above `moveRight`:

```js
// Move the current piece one column to the right
function moveRight() {
```

```bash
git add index.js
git commit -m "Add comment above moveRight"
```

### Step 2: Add a commit to main

```bash
git checkout main
```

Open `index.html`. Add a comment in the `<head>`:

```html
<!-- Stack Overflown: a dev-themed puzzle game -->
```

```bash
git add index.html
git commit -m "Add HTML comment to head"
```

### Step 3: Check the diverged state

```bash
git log --all --graph --oneline
```

You'll see `main` and `feature/rebase-practice` have diverged — they share a common ancestor but each has commits the other doesn't.

### Step 4: Rebase

```bash
git checkout feature/rebase-practice
git rebase main
```

Git replays your two commits on top of the new `main`. Watch the output — it'll say something like:

```
Successfully rebased and updated refs/heads/feature/rebase-practice.
```

### Step 5: Observe the result

```bash
git log --all --graph --oneline
```

The history is now linear. Your two commits sit directly after the `main` commit. No merge commit, no diverging lines.

Compare the commit hashes to what you saw before the rebase — they're different. D and E became D' and E'.

### Step 6: Fast-forward merge

Since the history is linear, merging back into `main` is a clean fast-forward:

```bash
git checkout main
git merge feature/rebase-practice
git log --graph --oneline
```

Perfectly linear. No merge commit needed.

---

## Lab 2 — Interactive rebase

Interactive rebase (`git rebase -i`) lets you edit, reorder, squash, rename, or drop commits before they land anywhere. It's the tool for cleaning up a messy branch before opening a PR.

### The commands

When you run `git rebase -i HEAD~4`, Git opens an editor showing your last 4 commits, oldest first:

```
pick a1b2c3 Add comment above moveLeft
pick d4e5f6 fix
pick g7h8i9 fix again
pick j0k1l2 Add comment above moveRight
```

Each line starts with a command. Change the command to change what happens to that commit:

| Command | What it does |
|---|---|
| `pick` | Keep the commit as-is |
| `reword` | Keep the commit, but edit the message |
| `squash` | Merge into the previous commit, combine messages |
| `fixup` | Merge into the previous commit, discard this message |
| `drop` | Delete the commit entirely |
| `edit` | Pause the rebase here so you can amend the commit |

You can also reorder lines to reorder commits. Git replays them top to bottom.

### Lab task: clean up 4 messy commits into 2

Create a branch with 4 commits — two real changes and two "oops" fixes:

```bash
git checkout -b practice/interactive-rebase
```

**Commit 1:** Add a comment above `hardDrop` in `index.js`:

```js
// Drop the piece instantly to the bottom
function hardDrop() {
```

```bash
git add index.js
git commit -m "Add comment above hardDrop"
```

**Commit 2:** A typo fix (simulate an oops):

```bash
# Open index.js, change "instantly" to "instantly" (or any trivial edit)
git add index.js
git commit -m "fix typo"
```

**Commit 3:** Add a comment above `rotate` in `index.js`:

```js
// Rotate the current piece 90 degrees clockwise
function rotate() {
```

```bash
git add index.js
git commit -m "Add comment above rotate"
```

**Commit 4:** Another fix:

```bash
# Make another trivial edit to index.js
git add index.js
git commit -m "fix"
```

Check what you have:

```bash
git log --oneline -4
```

Now clean it up:

```bash
git rebase -i HEAD~4
```

Your editor opens. Change it to look like this (squash the fixes into their real commits):

```
pick a1b2c3 Add comment above hardDrop
fixup d4e5f6 fix typo
pick g7h8i9 Add comment above rotate
fixup j0k1l2 fix
```

Save and close the editor. Git replays the commits, folding the fixups in silently.

Check the result:

```bash
git log --oneline -2
```

Two clean commits. The "fix" and "fix typo" commits are gone.

---

## Lab 3 — Rebase conflict

Rebase conflicts work like merge conflicts — same markers, same resolution process — but they happen one commit at a time as Git replays each commit onto the new base.

### Setup: create a conflict

```bash
git checkout main
```

Open `index.js`. Find the `moveDown` function and add a comment:

```js
// Move the piece down one row, lock it if it hits the bottom
function moveDown() {
```

```bash
git add index.js
git commit -m "Add comment above moveDown on main"
```

Now create a branch that also touches `moveDown`:

```bash
git checkout -b practice/rebase-conflict
```

Open `index.js`. Change the same comment line to something different:

```js
// Drop piece by one row; lock and spawn new piece on collision
function moveDown() {
```

```bash
git add index.js
git commit -m "Reword moveDown comment"
```

### Trigger the conflict

```bash
git rebase main
```

Git stops mid-rebase:

```
CONFLICT (content): Merge conflict in index.js
error: could not apply abc1234... Reword moveDown comment
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
```

### Your three options

**Option 1: Resolve and continue**

Open `index.js`. Find the conflict markers. Pick the version you want (or blend both). Remove all markers. Then:

```bash
git add index.js
git rebase --continue
```

Git opens an editor for the commit message (you can keep it or change it). Save and close. The rebase continues with the next commit.

**Option 2: Skip this commit**

If the conflicting commit is no longer needed (maybe the change was already made on `main`):

```bash
git rebase --skip
```

This discards the current commit and moves to the next one. Use carefully — you're throwing away a commit.

**Option 3: Abort entirely**

If you want to get back to where you started, as if the rebase never happened:

```bash
git rebase --abort
```

Your branch returns to its pre-rebase state. Nothing is lost. This is always available until you run `--continue` on the final commit.

### Check the state at any point

```bash
git status
```

During a rebase, `git status` tells you which commit is being applied, which files are conflicted, and what commands are available. Read it — it's more informative than usual.

---

## Challenge

No steps. Here's the goal.

Create a feature branch with 6 commits:
- 3 real, meaningful changes to the Stack Overflown game files
- 3 "oops" commits that fix mistakes from the real changes (commit messages like `"fix"`, `"oops"`, `"actually this"`)

Then:

1. Use `git rebase -i` to produce exactly 3 clean commits — one per real change, with the oops commits folded in. Each commit message should describe what the change actually does.
2. Add a new commit to `main` (any small change) to simulate `main` moving on.
3. Rebase your cleaned-up feature branch onto the updated `main`.

When you're done: `git log --graph --oneline` should show a perfectly linear history with exactly 3 feature commits sitting on top of the latest `main` commit. No merge commits, no oops commits, no diverging lines.

---

## Boss Fight 🔴

> A rebase was abandoned halfway through. The repo is in an unknown state. Figure out what happened, abort cleanly, and redo the rebase correctly.

Navigate to `broken-repos/br04-rebase-gone-wrong/` and run the setup:

```bash
cd broken-repos/br04-rebase-gone-wrong
bash setup.sh
cd br04-workspace
```

Start here:

```bash
git status
```

`git status` during a broken rebase is unusually informative — read every line. It'll tell you what operation is in progress, which commit was being applied, and what files are conflicted.

From there, you're on your own. Some things that might be useful:

- `git rebase --abort` gets you back to a clean state if you want to start over
- `git log --all --graph --oneline` shows you what the rebase was trying to do
- `cat .git/rebase-merge/head-name` tells you which branch was being rebased
- `cat .git/rebase-merge/onto` tells you what it was being rebased onto

The goal: end up with a clean, linear history where the feature branch commits sit on top of `main`. No conflict markers in any file. No rebase in progress.

---

## What's next

→ [m14-debugging](../m14-debugging/README.md) — `git bisect`, `git blame`, and `git log` tricks for tracking down exactly when and where something broke.

---

**Difficulty:** 🔴 Advanced | **Est. time:** 50 min | **Prerequisites:** [m09-remotes](../../02-collaboration/m09-remotes/README.md), [m11-pull-requests](../../02-collaboration/m11-pull-requests/README.md)
