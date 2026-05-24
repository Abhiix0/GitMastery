# Lab — Three ways to merge

**Working directory:** `sandbox/stack-overflown/`

You're going to do three different merge types back-to-back and compare what the history looks like after each one.

---

## Part 1 — Fast-forward merge

**1. Create a branch:**
```bash
git checkout -b feature/ff-test
```

**2. Make two commits on it:**
```bash
# edit index.js: add a comment like // ff-test change 1
git add . && git commit -m "ff-test: add comment"

# edit index.js again: change a variable name or add another comment
git add . && git commit -m "ff-test: tweak variable name"
```

**3. Merge back to main:**
```bash
git checkout main
git merge feature/ff-test
```

**4. Check the log:**
```bash
git log --oneline
```
Linear history. No merge commit. Main just moved its pointer forward — that's a fast-forward.

**5. Clean up:**
```bash
git branch -d feature/ff-test
```

---

## Part 2 — No-fast-forward merge

**1. Create a branch:**
```bash
git checkout -b feature/no-ff-test
```

**2. Make two commits on it** (same idea — small edits to `index.js`).

**3. Merge with `--no-ff`:**
```bash
git checkout main
git merge --no-ff feature/no-ff-test -m "Merge: no-ff-test feature"
```

**4. Check the log:**
```bash
git log --oneline --graph
```
You'll see the branch shape preserved — two lines converging into a merge commit. Even though a fast-forward was possible, you forced a merge commit to keep the history explicit.

**5. Clean up:**
```bash
git branch -d feature/no-ff-test
```

---

## Part 3 — Squash merge

**1. Create a branch:**
```bash
git checkout -b feature/squash-test
```

**2. Make three commits with intentionally bad messages:**
```bash
git add . && git commit -m "wip"
git add . && git commit -m "fix"
git add . && git commit -m "fix again"
```

**3. Squash merge:**
```bash
git checkout main
git merge --squash feature/squash-test
```

**4. Check status:**
```bash
git status
```
All the changes are staged but there's no commit yet. `--squash` collapses everything into a single staged changeset and hands it to you to commit.

**5. Commit with a clean message:**
```bash
git commit -m "Add squash-test feature (cleaned up)"
```

**6. Check the log:**
```bash
git log --oneline
```
One clean commit. No branch shape, no "wip" / "fix" noise in the history.

**7. Clean up:**
```bash
git branch -d feature/squash-test
```
Note: Git may warn that the branch isn't fully merged (because the squash commit isn't a real merge). Use `-D` to force delete:
```bash
git branch -D feature/squash-test
```

---

## Verification

`git log --oneline --graph` shows you the three different history shapes — linear, branched with merge commit, and linear again.
