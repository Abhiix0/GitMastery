# m10-workflows

## What's this about

Knowing Git commands and knowing how to work with a team using Git are two different things. The commands are the easy part. The hard part is the workflow layer — the agreed patterns that stop five people from stepping on each other's work, creating unsolvable merge conflicts, and shipping broken code.

This module is about that layer. Not theory — the actual rhythm of what a normal day looks like when your team is using Git properly.

---

## The daily rhythm

Here's a typical feature development cycle. You're adding a pause feature to Stack Overflown. This is what it looks like when it goes well.

### 1. Sync before you start

Never start from a stale `main`. The first thing you do every morning, and before starting any new branch:

```bash
git checkout main
git pull origin main
```

If you branch from yesterday's `main` and someone merged three PRs overnight, you're already behind. You'll find out the hard way when you try to merge.

### 2. Create a feature branch

```bash
git checkout -b feature/pause-button
```

Name it something that tells your teammates what it does. `feature/pause-button` is fine. `fix/42` is acceptable if there's an issue. `my-branch` or `test` are not.

### 3. Make small, focused commits

Work on the pause feature. Commit as you go — not one giant commit at the end.

```bash
# Add the pause button to the HTML
git add index.html
git commit -m "Add pause button to game controls panel"

# Wire up the toggle logic in JS
git add index.js
git commit -m "Connect pause button to togglePause function"
```

Each commit should be a coherent unit. If you have to use "and" in the commit message, it's probably two commits.

### 4. Push the branch to remote

```bash
git push -u origin feature/pause-button
```

Push early, push often. This backs up your work and lets teammates see what you're doing. You're not pushing to `main` — you're pushing your branch.

### 5. Open a PR

When the feature is ready for review, open a PR on GitHub from `feature/pause-button` → `main`. Write a description that explains what changed and how to test it. See [m11-pull-requests](../m11-pull-requests/README.md) for what a good PR looks like.

### 6. Address review comments with new commits

Your reviewer asks you to change the button label from "Pause" to "⏸ Pause". Don't amend your previous commit — add a new one:

```bash
git add index.html
git commit -m "Update pause button label per review feedback"
git push
```

The PR updates automatically. The reviewer can see exactly what changed in response to their comment.

> Don't force-push during a review unless you're explicitly cleaning up history before merge. Rewriting commits mid-review makes it impossible for reviewers to see what changed since their last look.

### 7. Merge and delete the branch

Once approved, merge the PR on GitHub. Then clean up locally:

```bash
git checkout main
git pull origin main          # get the merged commit
git branch --delete feature/pause-button
git push origin --delete feature/pause-button
```

The branch served its purpose. It's gone. `main` has the feature.

---

## What "coordinating with teammates" actually means

### Always branch from the latest main

When you create a branch, you're taking a snapshot of `main` at that moment. If `main` moves forward while you're working — and it will — your branch is now behind.

```
main:    A ── B ── C ── D    ← teammates merged while you worked
                  \
feature:           E ── F    ← your work, branched from C
```

The longer you wait to deal with this, the worse it gets. D might have changed the same files you're working on.

### When main moves forward while you're on a branch

You have two options:

**Option 1: Merge main into your branch**

```bash
git checkout feature/pause-button
git merge main
```

This creates a merge commit on your branch that brings in everything from `main`. Your branch history shows the merge. It's honest — it records that you integrated at this point.

Use this when: you're on a shared branch, you want to preserve the exact history, or you're not comfortable with rebase yet.

**Option 2: Rebase your branch onto main**

```bash
git checkout feature/pause-button
git rebase main
```

This replays your commits on top of the latest `main`, as if you'd started your branch from D instead of C. The history is linear and clean.

Use this when: you're on a personal branch, you want a clean history before opening a PR, and you understand what rebase does.

> Rebase rewrites commit hashes. Never rebase a branch that other people have pulled. See [m13-rebase](../../03-power-tools/m13-rebase/README.md) for the full picture.

### How to avoid "my branch is 40 commits behind main"

The answer is boring: merge or rebase frequently, and keep PRs small.

A branch that lives for two days and touches one feature is easy to keep in sync. A branch that lives for two weeks and touches half the codebase is a merge conflict waiting to happen.

Practical rules:
- Sync your branch with `main` at least once a day on active work
- If your PR is getting large, consider splitting it
- If you're blocked waiting for review, start the next small thing on a new branch rather than piling more onto the current one

---

## Common team problems and how to avoid them

| Problem | What causes it | How to prevent it |
|---|---|---|
| Massive merge conflicts | Long-lived branches that diverge from `main` | Merge or rebase from `main` frequently; keep branches short-lived |
| Painful, slow code reviews | PRs with 800+ line diffs touching unrelated things | One concern per PR; keep diffs small and focused |
| Broken `main` | Merging untested or unreviewed code | Require PR reviews; run CI on every PR before merge |
| "What's even on main right now?" | Vague commit messages and PR descriptions | Write commit messages that describe the change, not the action |
| Teammate's local branch is broken | Someone force-pushed a shared branch | Never force-push `main` or any branch others have pulled |
| Duplicate work | Nobody knows what anyone else is working on | Use issues or a board to claim work before starting; branch names help too |

---

## Lab

### Part 1: Simulate the daily rhythm

Make sure you're in `sandbox/stack-overflown/` on a clean `main`:

```bash
cd sandbox/stack-overflown
git checkout main
git status
```

**Step 1: Sync (simulate a pull)**

```bash
git log --oneline -3   # note where main is
```

**Step 2: Create a feature branch**

```bash
git checkout -b feature/score-label-update
```

**Step 3: Make two focused commits**

Open `index.html`. Find the `<h3>Score</h3>` label and change it to `<h3>Current Score</h3>`:

```bash
git add index.html
git commit -m "Rename Score label to Current Score"
```

Open `index.js`. Add a comment above `updateScore`:

```js
// Updates the score display after each pattern match
function updateScore() {
```

```bash
git add index.js
git commit -m "Add comment above updateScore"
```

**Step 4: Push the branch (if you have a remote)**

```bash
git push -u origin feature/score-label-update
```

If you don't have a remote set up, skip this step — the rest of the lab still works locally.

**Step 5: Merge back to main**

```bash
git checkout main
git merge --no-ff feature/score-label-update -m "Add score label update and comment"
git branch --delete feature/score-label-update
```

Check the graph:

```bash
git log --all --graph --oneline
```

---

### Part 2: Simulate "main moved while you were working"

**Step 1: Create a feature branch**

```bash
git checkout -b feature/controls-update
```

Make a change to `index.html` — update the controls section, add a line, anything:

```bash
git add index.html
git commit -m "Update controls section in UI"
```

**Step 2: Simulate a teammate merging to main**

Switch to `main` and add a commit there:

```bash
git checkout main
```

Open `index.js` and add a comment at the very top of the file:

```js
// Stack Overflown — main game logic
```

```bash
git add index.js
git commit -m "Add file header comment to index.js"
```

**Step 3: Check the diverged state**

```bash
git log --all --graph --oneline
```

You'll see `main` and `feature/controls-update` have diverged.

**Step 4: Bring main into your feature branch**

```bash
git checkout feature/controls-update
git merge main
```

If there are no conflicts (likely, since you touched different files), the merge completes automatically. If there are conflicts, resolve them the same way as m07.

Check the graph again:

```bash
git log --all --graph --oneline
```

Your feature branch now includes the `main` commit. It's up to date.

**Step 5: Merge back to main**

```bash
git checkout main
git merge --no-ff feature/controls-update -m "Update controls section"
git branch --delete feature/controls-update
```

Final graph:

```bash
git log --all --graph --oneline
```

---

## Challenge

You have a feature branch that's 5 commits behind `main`. Someone else just merged a change that touches the same file you're editing — `index.js`. Get your branch up to date, keep your work intact, and end up with a clean merge into `main`.

Set it up yourself: create the feature branch, add commits to both `main` and the branch that touch `index.js`, then figure out how to bring them together without losing either set of changes. You'll hit a conflict. Resolve it.

When you're done, run `git log --all --graph --oneline`. The graph should show your feature branch merging cleanly into `main` with both sets of changes present. No steps given — use what you know.

---

## What's next

→ [m11-pull-requests](../m11-pull-requests/README.md) — the PR is where the daily rhythm meets your teammates. How to write one worth reviewing.

→ [m12-team-strategies](../m12-team-strategies/README.md) — how different teams structure their branches at scale: GitHub Flow, Git Flow, trunk-based development.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 35 min | **Prerequisites:** [m09-remotes](../m09-remotes/README.md), [m05-branching](../../01-solo-workflows/m05-branching/README.md)
