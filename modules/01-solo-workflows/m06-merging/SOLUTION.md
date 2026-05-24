# Solution — m06

> **Try the challenge yourself first.**

---

## Answer

The merge strategy is `--squash`. It collapses all commits on the branch into a single staged changeset, then you write one clean commit message that summarizes the actual work.

```bash
# Set up the messy branch
git checkout -b feature/messy-work

git add . && git commit -m "Add score display"
git add . && git commit -m "fix"
git add . && git commit -m "Add timer logic"
git add . && git commit -m "wip"
git add . && git commit -m "Add game over screen"

# Squash merge into main
git checkout main
git merge --squash feature/messy-work

# Write one clean commit
git commit -m "Add score display, timer logic, and game over screen"

# Verify
git log --oneline

# Clean up (needs -D because squash isn't a real merge)
git branch -D feature/messy-work
```

## Why squash here

A squash merge is the right call when:
- The branch commits are messy, iterative, or don't tell a coherent story
- You want main's history to stay clean and readable
- You don't need to preserve the individual steps

The tradeoff: you lose the granular history of that branch. Once it's squashed and the branch is deleted, you can't see the individual steps anymore. If that history matters, use `--no-ff` instead and keep the branch shape.

Pick based on whether the individual commits have value to future readers.
