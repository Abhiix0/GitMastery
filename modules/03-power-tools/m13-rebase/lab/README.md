# Lab — Rebase in three modes

**Working directory:** `sandbox/stack-overflown/`

---

## Part 1 — Basic rebase (linear history)

**1. Create a feature branch:**
```bash
git checkout -b feature/rebase-practice
```

**2. Add 3 commits:**
```bash
# edit index.js — add a score animation stub
git add . && git commit -m "Add score animation"

# edit index.js — adjust timing value
git add . && git commit -m "Fix animation timing"

# edit index.js — tweak speed constant
git add . && git commit -m "Tweak animation speed"
```

**3. Switch to main and add a commit there:**
```bash
git checkout main
# edit style.css — update the CSS reset block
git add . && git commit -m "Update CSS reset"
```

Main has now moved ahead of where the feature branch started. If you merged, you'd get a merge bubble.

**4. Rebase instead:**
```bash
git checkout feature/rebase-practice
git rebase main
```

Git replays your 3 commits on top of main's new commit. No merge commit, no bubble.

**5. Check the history:**
```bash
git log --graph --oneline
```
Perfectly linear. The feature commits sit directly above the CSS reset commit.

**6. Fast-forward merge:**
```bash
git checkout main
git merge feature/rebase-practice
```
Because the feature branch is directly ahead of main, this is a fast-forward — no merge commit needed.

---

## Part 2 — Interactive rebase (clean up history)

**1. Create a branch with intentionally messy history:**
```bash
git checkout -b feature/messy-history
git add . && git commit -m "WIP"
git add . && git commit -m "fix typo"
git add . && git commit -m "Add feature X"
git add . && git commit -m "fix feature X"
git add . && git commit -m "actually fix feature X"
```

**2. Start an interactive rebase over the last 5 commits:**
```bash
git rebase -i HEAD~5
```

Your editor opens with something like:
```
pick a1b2c3 WIP
pick d4e5f6 fix typo
pick g7h8i9 Add feature X
pick j0k1l2 fix feature X
pick m3n4o5 actually fix feature X
```

**3. Edit it to squash the noise:**
```
pick a1b2c3 WIP
s    d4e5f6 fix typo
pick g7h8i9 Add feature X
s    j0k1l2 fix feature X
s    m3n4o5 actually fix feature X
```

`s` (squash) folds a commit into the one above it. Save and close.

**4. Git opens a second editor for the combined commit messages.** Rewrite them:
- First combined commit: `Add initial game scaffolding`
- Second combined commit: `Add feature X with timing fix`

Save and close.

**5. Check the result:**
```bash
git log --oneline
```
Two clean commits instead of five.

---

## Part 3 — Rebase conflict

**1. Create a branch and edit line 1 of `index.js`:**
```bash
git checkout -b feature/conflict-rebase
# change line 1 of index.js to: // feature version
git add . && git commit -m "Feature branch change"
```

**2. Switch to main and edit the same line:**
```bash
git checkout main
# change line 1 of index.js to: // main version
git add . && git commit -m "Main branch change"
```

**3. Rebase the feature branch onto main:**
```bash
git checkout feature/conflict-rebase
git rebase main
```

Conflict. Git stops mid-replay and tells you which file to fix.

**4. Open `index.js`, resolve the conflict markers, keep what makes sense.**

**5. Continue the rebase:**
```bash
git add index.js
git rebase --continue
```

If there were more commits to replay, Git would continue. Here it finishes.

**6. Check the graph:**
```bash
git log --graph --oneline
```
The feature commit is now above main's commit. Linear history.

---

## Verification

You can explain the difference between rebase and merge. `git log --graph` shows you why — one produces a bubble, the other doesn't.
