# Lab — Cherry-pick, internals, and worktrees

**Working directory:** `sandbox/stack-overflown/`

---

## Part 1 — Cherry-pick

Cherry-pick copies a single commit from anywhere in history and applies it to your current branch.

**1. Create a branch with several commits:**
```bash
git checkout -b feature/all-features
git add . && git commit -m "Add pause button"
git add . && git commit -m "Fix pause button timing"
git add . && git commit -m "Add high score"
git add . && git commit -m "Update colors"
```

Only "Add high score" is ready for main. The rest need more work.

**2. Switch to main:**
```bash
git checkout main
```

**3. Find the hash of the "Add high score" commit:**
```bash
git log feature/all-features --oneline
```

**4. Cherry-pick it:**
```bash
git cherry-pick <hash>
```

**5. Check main's log:**
```bash
git log --oneline
```
"Add high score" is on main — but with a **different hash** than on the feature branch.

**6. Check the feature branch:**
```bash
git log feature/all-features --oneline
```
The original commit is still there, unchanged.

The hash changed because the hash is computed from the content + the parent commit. Same content, different parent → different hash. That's not a bug — it's how Git works.

---

## Part 2 — Internals

Git stores everything as objects: commits, trees, and blobs. This part walks the object graph by hand.

**1. Get the latest commit hash:**
```bash
git log --oneline -1
```

**2. Inspect the commit object:**
```bash
git cat-file -t <commit-hash>   # prints "commit"
git cat-file -p <commit-hash>   # prints tree, parent, author, message
```

**3. Copy the tree hash from the output. Inspect it:**
```bash
git cat-file -p <tree-hash>
```
You'll see a list of blobs (files) and subtrees (directories) with their hashes.

**4. Copy a blob hash. Inspect it:**
```bash
git cat-file -p <blob-hash>
```
That's the raw file content — no metadata, just bytes.

**5. Look at what HEAD actually is:**
```bash
cat .git/HEAD
```
Prints: `ref: refs/heads/main`

**6. Follow the ref:**
```bash
cat .git/refs/heads/main
```
Prints a commit hash — the same one from step 1.

A branch is literally a text file containing a 40-character hash. When you commit, Git writes the new hash into that file. That's the entire mechanism.

---

## Part 3 — Worktrees

A worktree lets you check out a second branch into a separate directory — without stashing, without switching branches, without touching your current work.

**1. Add a worktree on a new branch:**
```bash
git worktree add ../game-hotfix -b hotfix/critical-bug
```

This creates `../game-hotfix/` as a full working directory, checked out on `hotfix/critical-bug`.

**2. Confirm it has the repo files:**
```bash
ls ../game-hotfix
```

**3. Make a commit in the worktree:**
```bash
cd ../game-hotfix
echo "// hotfix applied" >> index.js
git add .
git commit -m "Apply critical hotfix"
cd -
```

**4. Back in your main repo, see the hotfix commit:**
```bash
git log hotfix/critical-bug --oneline
```

**5. List all active worktrees:**
```bash
git worktree list
```

**6. Remove the worktree when done:**
```bash
git worktree remove ../game-hotfix
```

---

## Verification

You can explain:
- Why cherry-pick creates a new hash (same content, different parent)
- What `git cat-file -p` does at each level of the object graph
- When you'd use a worktree instead of `git stash` (when the context switch is long enough that you want a real separate directory, not just a saved state)
