# m16-advanced

You don't need this to use Git well. But once you understand it, everything else makes more sense.

## What's this about

This module is for when "how do I use it" isn't enough — you want to know what Git is actually doing underneath. Understanding Git's internals demystifies rebases, detached HEADs, history rewriting, and the occasional terrifying error message. Cherry-pick and worktrees are power tools that solve specific real problems you'll eventually run into. And the internals section isn't just trivia — once you see that a branch is literally a text file containing a hash, a lot of Git's behaviour stops feeling like magic and starts feeling obvious.

---

## git cherry-pick — take one commit from anywhere

Cherry-pick applies the changes from a specific commit onto your current branch. It doesn't move the commit — it creates a new one with the same diff but a different hash, a different parent, and a different timestamp.

### The use case

You're working on `feature/scoring-overhaul`. Three commits in, you realise commit #2 is a bug fix that needs to ship to `main` right now — the whole feature isn't ready, but that fix is. Cherry-pick lets you take exactly that commit and apply it to `main` without touching the rest of the feature branch.

```
main:     A ── B ── C
                     \
feature:              D ── E(fix) ── F
                               ↓
                          cherry-pick
                               ↓
main:     A ── B ── C ── E'   ← same fix, new hash
```

`E` stays on the feature branch. `E'` is a new commit on `main` with the same diff.

### Commands

```bash
# Apply a single commit
git cherry-pick <commit-hash>

# Apply a range of commits (exclusive of hash1, inclusive of hash2)
git cherry-pick <hash1>..<hash2>

# Apply changes but don't commit yet — lets you inspect or modify first
git cherry-pick --no-commit <hash>

# If cherry-pick hits a conflict, resolve it then:
git cherry-pick --continue

# Or bail out entirely:
git cherry-pick --abort
```

### What to watch for

Cherry-pick duplicates the commit with a new hash. If the original branch eventually gets merged into `main`, you'll have two commits with the same diff — one from the cherry-pick and one from the merge. Git usually handles this gracefully (the second application is a no-op), but it can create noise in the history. It's not a reason to avoid cherry-pick, just something to be aware of.

### Lab: cherry-pick a fix to main

**Step 1: Set up a feature branch with 3 commits**

```bash
cd sandbox/stack-overflown
git checkout main
git checkout -b feature/scoring-overhaul
```

**Commit 1 — a feature change:**

Open `index.js`. Add a comment above `checkPatternMatch`:

```js
// Check if the current board state matches the target pattern
function checkPatternMatch() {
```

```bash
git add index.js
git commit -m "Add comment above checkPatternMatch"
```

**Commit 2 — the bug fix (this is the one we need on main):**

Open `index.js`. Find `updateScore` and fix a subtle issue — the score display isn't updating the document title. Add one line:

```js
function updateScore() {
  document.getElementById("score").textContent = score;
  document.title = "Stack Overflown — Score: " + score;
}
```

```bash
git add index.js
git commit -m "Fix: sync score to document title on update"
```

**Commit 3 — more feature work:**

Open `index.js`. Add a comment above `clearPattern`:

```js
// Clear all blocks from the board after a successful pattern match
function clearPattern(startRow, startCol) {
```

```bash
git add index.js
git commit -m "Add comment above clearPattern"
```

**Step 2: Get the hash of the bug fix commit**

```bash
git log --oneline
```

Copy the hash of `"Fix: sync score to document title on update"` — it's the middle commit.

**Step 3: Cherry-pick it onto main**

```bash
git checkout main
git cherry-pick <hash-of-fix-commit>
```

**Step 4: Verify**

```bash
git log --oneline main
```

The fix commit is on `main`. Check the feature branch:

```bash
git log --oneline feature/scoring-overhaul
```

All three commits are still there, untouched. The cherry-pick didn't remove anything from the feature branch — it copied the diff.

Compare the hashes: the commit on `main` has a different hash than the one on `feature/scoring-overhaul`. Same diff, different object.

---

## Git internals — what Git actually is

> Git is a content-addressable key-value store with a version control interface built on top.

That sentence sounds dense. Here's what it means:

- **Key-value store**: you give Git some content, Git gives you back a hash (the key). Give Git the same content again, you get the same hash. Always.
- **Content-addressable**: the key is derived from the content itself (SHA-1 hash). Two identical files have the same hash. One byte different, completely different hash.
- **Version control interface**: `git commit`, `git branch`, `git merge` — these are all just operations on that underlying key-value store.

Everything Git knows about your project lives in `.git/objects/`. Every file, every directory listing, every commit, every tag — all stored as objects, all identified by their SHA-1 hash.

### The four object types

**blob** — the contents of a file. Not the filename, not the permissions — just the raw bytes. Two files with identical content share one blob.

**tree** — a directory listing. Contains references to blobs (files) and other trees (subdirectories), along with filenames and permissions. A tree is a snapshot of a directory at a point in time.

**commit** — a snapshot of the entire project. Contains: a reference to the root tree, references to parent commit(s), author name/email/timestamp, committer name/email/timestamp, and the commit message.

**tag** — an annotated pointer to a commit. Contains the tag name, tagger info, date, message, and a reference to the commit it points to. (Lightweight tags are just refs, not objects.)

The relationship:

```
commit
  └── tree (root directory)
        ├── blob (index.html)
        ├── blob (style.css)
        └── tree (src/)
              ├── blob (index.js)
              └── blob (patterns.js)
```

Every commit points to a complete snapshot of the project — not a diff, not a delta. The efficiency comes from the fact that unchanged files share blobs across commits.

### Inspecting objects

```bash
git cat-file -t <hash>    # show the object type (blob, tree, commit, tag)
git cat-file -p <hash>    # show the object contents in human-readable form
git cat-file -s <hash>    # show the object size in bytes
```

### Lab: walk the object graph by hand

Make sure you're in `sandbox/stack-overflown/` with at least one commit.

**Step 1: Get a commit hash**

```bash
git log --oneline -1
```

Copy the hash. Let's call it `COMMIT`.

**Step 2: Inspect the commit object**

```bash
git cat-file -p COMMIT
```

Output looks like:

```
tree 4b825dc642cb6eb9a060e54bf8d69288fbee4904
parent a1b2c3d4e5f6...
author GitMastery Learner <learner@gitmastery.local> 1716000000 +0000
committer GitMastery Learner <learner@gitmastery.local> 1716000000 +0000

Your commit message here
```

Copy the `tree` hash. Let's call it `TREE`.

**Step 3: Inspect the tree object**

```bash
git cat-file -p TREE
```

Output looks like:

```
100644 blob a8c3f2... index.html
100644 blob 9d1e4b... index.js
100644 blob 7f2a1c... patterns.js
100644 blob 3e8b5d... style.css
```

Each line: `permissions type hash filename`. Copy the hash for `index.js`. Let's call it `BLOB`.

**Step 4: Inspect the blob object**

```bash
git cat-file -p BLOB
```

You'll see the raw contents of `index.js` — the actual JavaScript source code, exactly as it exists in the file.

You just walked the entire Git object graph by hand: commit → tree → blob → file contents. This is everything Git stores. There's nothing else.

**Step 5: Verify the type of each**

```bash
git cat-file -t COMMIT    # commit
git cat-file -t TREE      # tree
git cat-file -t BLOB      # blob
```

### Refs are just files

Branches, HEAD, and tags are not stored as objects. They're plain text files containing a hash.

```bash
cat .git/HEAD
# ref: refs/heads/main

cat .git/refs/heads/main
# a1b2c3d4e5f6789...  ← the commit hash main points to
```

When you run `git checkout -b feature/x`, Git writes one file: `.git/refs/heads/feature/x` containing the current commit hash. That's the entire operation.

When you make a new commit, Git:
1. Creates a blob for each changed file
2. Creates a new tree reflecting the updated directory
3. Creates a commit object pointing to that tree and the previous commit
4. Updates the ref file (e.g. `.git/refs/heads/main`) to point to the new commit hash

That's all of `git commit`. Four steps, all file writes.

```bash
# See all refs in the repo
find .git/refs -type f

# See what HEAD points to right now
cat .git/HEAD

# See what main points to
cat .git/refs/heads/main

# Confirm they match
git rev-parse HEAD
git rev-parse main
```

---

## git worktree — two branches checked out simultaneously

A worktree is a separate working directory linked to the same repository. Each worktree can have a different branch checked out. They share the same `.git/` directory and object store — no duplication of history.

### The use case

You're mid-feature on `feature/scoring-overhaul`. A production crash is reported. You need to check out `main`, reproduce the bug, and write a fix — but you don't want to commit half-finished feature work, and you don't want to stash and context-switch.

With worktrees, you open a second directory on `main` while your feature directory stays exactly as it is.

### Commands

```bash
# Create a new worktree at ../game-hotfix checked out to hotfix/crash-fix
git worktree add ../game-hotfix hotfix/crash-fix

# Create a worktree on a new branch
git worktree add -b hotfix/crash-fix ../game-hotfix main

# List all worktrees
git worktree list

# Remove a worktree (after you're done with it)
git worktree remove ../game-hotfix

# Prune stale worktree references (if you deleted the folder manually)
git worktree prune
```

### Lab: two branches at once

**Step 1: Confirm you're on a feature branch with uncommitted work**

```bash
cd sandbox/stack-overflown
git checkout -b feature/worktree-demo
echo "// worktree demo" >> index.js
# Don't commit — leave it as an uncommitted change
git status
```

**Step 2: Create a worktree for main**

```bash
git worktree add ../stack-overflown-main main
```

Git creates a new directory `../stack-overflown-main` checked out to `main`. Your current directory stays on `feature/worktree-demo` with your uncommitted change intact.

**Step 3: Work in both simultaneously**

In your current terminal (feature branch):

```bash
git status    # shows your uncommitted change
ls            # your working files
```

Open a second terminal and navigate to the worktree:

```bash
cd ../stack-overflown-main
git status    # clean, on main
git log --oneline -3
```

Make a change in the main worktree:

```bash
echo "// hotfix" >> index.js
git add index.js
git commit -m "Apply hotfix in worktree"
```

Back in your feature terminal — your uncommitted change is still there, untouched.

**Step 4: List worktrees**

From either directory:

```bash
git worktree list
```

Output shows both worktrees, their paths, and which branch each is on.

**Step 5: Clean up**

```bash
# From the feature branch directory
git worktree remove ../stack-overflown-main

# Clean up the demo branch
git restore index.js
git checkout main
git branch --delete feature/worktree-demo
```

### Constraints

- You can't check out the same branch in two worktrees simultaneously — Git prevents it
- Each worktree needs its own disk space for the working files (but shares the object store)
- Worktrees work with all normal Git commands — commit, push, pull, merge, rebase

---

## The mental model payoff

Now that you've seen the internals, a lot of Git's behaviour that used to feel arbitrary should click into place.

**Rebase** — creates new commit objects with different parent references. The diffs are the same; the objects are new. That's why hashes change. That's why you can't rebase shared branches — other people have references to the old objects, and those objects don't disappear just because you stopped pointing at them.

**Detached HEAD** — `HEAD` normally contains `ref: refs/heads/main`, which points to a commit. In detached HEAD, `HEAD` contains a commit hash directly. There's no branch ref being updated when you commit. The commits exist as objects, but nothing permanent points to them — which is why they become unreachable when you switch away.

**Force push** — moves a ref file to point at a different commit. The old commits don't disappear immediately (they're still in `.git/objects/`), but they're no longer reachable from the branch. Anyone who had the old ref value now has a reference to commits that the remote no longer acknowledges. That's the chaos.

**`git gc`** — garbage collection. Finds objects with no refs pointing to them (directly or transitively) and deletes them. This is why `git reflog` works for 30–90 days but not forever — eventually `gc` runs and the unreachable objects are gone.

**Merge vs rebase** — both integrate changes from one branch into another. Merge creates a new commit object with two parents. Rebase creates new commit objects with one parent each (the tip of the target branch). Same end state in the working directory; different object graph.

---

## Challenge

The game has a hotfix on a `release/v1` branch that needs to get to `main` without merging the whole branch — there's unfinished work on it that isn't ready to ship. The hotfix is exactly one commit. Get it to `main`, verify `main` is in a working state, and keep the `release/v1` branch intact with all its commits.

Set up the scenario yourself: create `release/v1` from `main`, add two commits (one unfinished feature, one hotfix), then figure out how to get only the hotfix to `main`.

When the hotfix is on `main`, use `git cat-file` to inspect the cherry-picked commit object. Find its tree hash, walk down to the blob that contains the fix, and confirm the content is what you expect. Write down the chain: `commit hash → tree hash → blob hash → file content`. That chain is your proof that you understand what happened at the object level.

---

**Difficulty:** 🔴 Advanced | **Est. time:** 50 min | **Prerequisites:** [m13-rebase](../m13-rebase/README.md), [m14-debugging](../m14-debugging/README.md)
