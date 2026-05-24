# Lab — Implementing GitHub Flow

**Working directory:** `sandbox/stack-overflown/`

GitHub Flow in one sentence: branch off main, do the work, open a PR, merge, delete the branch, repeat. That's it. This lab runs through one complete cycle.

---

## Steps

**1. Start from a clean, up-to-date main:**
```bash
git checkout main
git pull
```

**2. Create a descriptive feature branch:**
```bash
git checkout -b feature/score-multiplier
```
Branch names should say what the branch does. `feature/score-multiplier` is clear. `my-branch` or `fix` is not.

**3. Implement the feature across 3 commits:**

Commit 1 — add the state variable to `index.js`:
```js
let multiplier = 1;
```
```bash
git add . && git commit -m "Add multiplier variable to game state"
```

Commit 2 — use it in the score logic:
```js
// In your updateScore function:
score += points * multiplier;
```
```bash
git add . && git commit -m "Apply multiplier in updateScore function"
```

Commit 3 — show it in the UI, add somewhere in `index.html`:
```html
<span id="multiplier-display">Multiplier: 1x</span>
```
```bash
git add . && git commit -m "Display multiplier value in UI"
```

**4. Push the branch:**
```bash
git push origin feature/score-multiplier
```

**5. Open a PR on GitHub:**
- Title: `Add score multiplier`
- Description: what it does, how to test it (open the game, check the multiplier display shows "1x")

**6. "Review" it yourself:**
- Go to **Files changed**
- Find where you named the variable `multiplier`
- Leave a comment: "Should this be `scoreMultiplier` to be more explicit?"

**7. Address the comment — make the rename in a new commit:**
```bash
# Rename multiplier → scoreMultiplier in index.js and index.html
git add .
git commit -m "Rename: multiplier → scoreMultiplier for clarity"
git push origin feature/score-multiplier
```

**8. Merge the PR** on GitHub (Squash and merge).

**9. Sync locally and clean up:**
```bash
git checkout main
git pull
git branch -d feature/score-multiplier
```

**10. Tag the release:**
```bash
git tag -a v1.2 -m "v1.2: Add score multiplier"
git push origin v1.2
```

**11. Create a `WORKFLOW.md` in the repo root:**

```markdown
# Team Workflow

We use GitHub Flow:

1. `main` is always deployable
2. All work happens on branches
3. Branches → PRs → review → squash merge → delete branch
4. Tag releases after merging significant features
```

```bash
git add WORKFLOW.md
git commit -m "Add team workflow documentation"
git push origin main
```

---

## Verification

`git log --oneline` shows the squashed feature commit and the workflow doc commit on main. `git tag` shows `v1.2`. `git branch -a` shows no `feature/score-multiplier`.
