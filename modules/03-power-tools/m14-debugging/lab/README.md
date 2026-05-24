# Lab — Debugging with Git

> **Before starting:** run the setup script to create the practice workspace:
> ```bash
> bash modules/03-power-tools/m14-debugging/lab/bisect-setup.sh
> ```
> This creates a `bisect-workspace/` directory with a 10-commit repo where commit 7 introduced a bug in `calculateScore`.

---

## Part 1 — git blame

**1. Navigate into the workspace:**
```bash
cd bisect-workspace
```

**2. Run blame on `index.js`:**
```bash
git blame index.js
```

Each line shows: commit hash | author | date | line number | content.

**3. Find the line containing `return score * NaN`.** Note the commit hash next to it.

**4. Inspect that commit:**
```bash
git show <that-hash>
```

This shows the full diff for that commit — what was added, what was removed, and the commit message. You now know who changed it, when, and what else was in that commit.

---

## Part 2 — git log -S

`git log -S` searches for commits that added or removed a specific string. It's called a "pickaxe" search.

**1. Find which commit introduced "NaN":**
```bash
git log -S "NaN" --oneline
```

**2. Compare with message search:**
```bash
git log --grep="fix" --oneline
```

`--grep` searches commit messages. `-S` searches the actual code changes. They answer different questions — use `-S` when you know what string appeared in the code, `--grep` when you remember something about the commit message.

---

## Part 3 — git bisect

Bisect does a binary search through your commit history to find the first bad commit. With 10 commits, it finds the answer in at most 4 steps instead of 10.

**1. Start bisect:**
```bash
git bisect start
```

**2. Mark the current state as broken:**
```bash
git bisect bad
```

**3. Mark the oldest commit as known-good:**
```bash
git bisect good HEAD~9
```

Git checks out the midpoint commit.

**4. Test the current state:**
```bash
node -e "const {calculateScore} = require('./index.js'); console.log(calculateScore(10))"
```

- Returns `1000` → `git bisect good`
- Returns `NaN` → `git bisect bad`

**5. Repeat** until Git prints: `<hash> is the first bad commit`.

**6. Exit bisect:**
```bash
git bisect reset
```
This returns you to HEAD.

**7. Confirm it's commit 7:**
```bash
git show <bad-commit-hash>
```

---

## Verification

You found the bug in ≤4 steps. `git bisect` halves the search space each time — that's log₂(10) ≈ 4 steps for 10 commits, log₂(1000) ≈ 10 steps for 1000 commits. It scales.
