# m07-conflicts

## What's actually happening

Merge conflicts aren't a sign something went wrong. They're Git saying: "Two people changed the same line and I don't know which version you want. You decide."

That's it. That's the whole thing.

Here's the analogy: imagine two people editing the same Google Doc at the same time. One person changes line 12 to say "Current Score". The other changes line 12 to say "Your Score". Google Docs would flag it. Git does the same — it just uses text markers instead of a UI popup.

When Git can't auto-merge, it edits the conflicted file directly and drops in markers that look like this:

```
<<<<<<< HEAD
  <h3>Current Score</h3>
=======
  <h3>Your Score</h3>
>>>>>>> feature/rename-score-label
```

Break it down:

- `<<<<<<< HEAD` — start of your version (the branch you're merging *into*)
- `=======` — the dividing line between the two versions
- `>>>>>>> feature/rename-score-label` — end of the incoming version (the branch you're merging *from*)

These are just text characters in your file. Git didn't break anything. It's waiting for you to pick a winner, then delete the markers. That's the whole resolution process.

---

## The three resolution strategies

Say you have this conflict in `index.html`:

```
<<<<<<< HEAD
  <h3>Current Score</h3>
  <div class="score" id="score">0</div>
  <div class="status" id="status">Playing...</div>
=======
  <h3>Your Score</h3>
  <div class="score" id="score">0</div>
  <div class="high-score" id="high-score">0</div>
>>>>>>> feature/add-high-score
```

### 1. Keep ours

Throw away the incoming changes. Keep exactly what HEAD has.

**Before (conflicted):**
```
<<<<<<< HEAD
  <h3>Current Score</h3>
  <div class="score" id="score">0</div>
  <div class="status" id="status">Playing...</div>
=======
  <h3>Your Score</h3>
  <div class="score" id="score">0</div>
  <div class="high-score" id="high-score">0</div>
>>>>>>> feature/add-high-score
```

**After (resolved):**
```html
  <h3>Current Score</h3>
  <div class="score" id="score">0</div>
  <div class="status" id="status">Playing...</div>
```

Delete everything from `<<<<<<< HEAD` to `>>>>>>> feature/add-high-score`, keeping only the top block.

---

### 2. Keep theirs

Throw away your version. Take exactly what the incoming branch has.

**After (resolved):**
```html
  <h3>Your Score</h3>
  <div class="score" id="score">0</div>
  <div class="high-score" id="high-score">0</div>
```

Delete everything, keeping only the bottom block.

---

### 3. Blend both (the most common real-world case)

Neither version is fully right. You want pieces of both. This is what you'll do 80% of the time on a real team.

**After (resolved):**
```html
  <h3>Current Score</h3>
  <div class="score" id="score">0</div>
  <div class="status" id="status">Playing...</div>
  <h3>High Score</h3>
  <div class="high-score" id="high-score">0</div>
```

You manually wrote the result you wanted. The label from HEAD, the status div from HEAD, and the high score div from the incoming branch. No markers, no leftover `=======`. Just clean HTML.

The rule: when you're done resolving, the file should look exactly like you'd write it from scratch. No conflict markers anywhere.

---

## Lab 1 — Your first conflict (guided)

You'll create two branches, make conflicting edits to `index.html`, merge them, and resolve the conflict three different ways to see how each feels.

### Setup

Make sure you're in the `sandbox/stack-overflown/` folder and on `main` with a clean working tree:

```bash
cd sandbox/stack-overflown
git status
```

Check your history so you have a baseline:

```bash
git log --oneline
```

### Step 1: Create two branches from the same point

```bash
git branch feature/score-label-a
git branch feature/score-label-b
```

### Step 2: Make a change on branch A

Switch to branch A:

```bash
git checkout feature/score-label-a
```

Open `index.html`. Find the score section (around line 20). Change the `<h3>Score</h3>` line to:

```html
<h3>Current Score</h3>
```

Stage and commit:

```bash
git add index.html
git commit -m "Rename score label to Current Score"
```

### Step 3: Make a conflicting change on branch B

Switch to branch B:

```bash
git checkout feature/score-label-b
```

Open `index.html`. Change the same `<h3>Score</h3>` line to something different:

```html
<h3>Your Score</h3>
```

Stage and commit:

```bash
git add index.html
git commit -m "Rename score label to Your Score"
```

### Step 4: Merge and hit the conflict

Switch back to `main`:

```bash
git checkout main
```

Merge branch A first — this will go cleanly:

```bash
git merge feature/score-label-a
```

Now merge branch B — this is where the conflict happens:

```bash
git merge feature/score-label-b
```

Git will stop and tell you there's a conflict:

```
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
```

Check the status to see what's in conflict:

```bash
git status
```

You'll see `index.html` listed under "both modified".

### Step 5: Resolve — Strategy 1 (keep ours)

Open `index.html`. Find the conflict markers. The file will look something like:

```
<<<<<<< HEAD
  <h3>Current Score</h3>
=======
  <h3>Your Score</h3>
>>>>>>> feature/score-label-b
```

Delete the markers and the incoming version. Keep only the HEAD version:

```html
<h3>Current Score</h3>
```

Save the file. Stage it and complete the merge:

```bash
git add index.html
git commit -m "Merge feature/score-label-b — keep Current Score label"
```

Check the graph:

```bash
git log --all --graph --oneline
```

You'll see the two branches converging into `main`.

### Step 6: Reset and try Strategy 2 (keep theirs)

To practice the other strategies, reset `main` back before the merge:

```bash
git reset --hard HEAD~1
```

Merge branch B again:

```bash
git merge feature/score-label-b
```

Open `index.html`, find the conflict. This time keep only the incoming version:

```html
<h3>Your Score</h3>
```

Save, stage, commit:

```bash
git add index.html
git commit -m "Merge feature/score-label-b — keep Your Score label"
```

### Step 7: Reset and try Strategy 3 (blend both)

Reset again:

```bash
git reset --hard HEAD~1
```

Merge branch B:

```bash
git merge feature/score-label-b
```

Open `index.html`. This time, write the result you actually want — maybe you want both labels, or a third option entirely:

```html
<h3>Score</h3>
```

Or blend them meaningfully:

```html
<h3>Current Score / High Score</h3>
```

Whatever makes sense. The point is: you're the author now. Git stepped aside.

Save, stage, commit:

```bash
git add index.html
git commit -m "Merge feature/score-label-b — blend both label approaches"
```

Final graph check:

```bash
git log --all --graph --oneline
```

---

## Lab 2 — VS Code merge editor

VS Code has a built-in merge editor that makes the three strategies visual. Here's how to use it.

### Triggering it

When you hit a conflict, open the conflicted file in VS Code. You'll see the conflict markers highlighted with colored backgrounds and action buttons above each block.

Alternatively, in the **Source Control** tab, click the conflicted file — VS Code may offer to open the **Merge Editor** view directly.

### The buttons

**Accept Current Change** — keeps your version (HEAD). Equivalent to Strategy 1.

**Accept Incoming Change** — keeps the incoming branch's version. Equivalent to Strategy 2.

**Accept Both Changes** — inserts both versions one after the other. A starting point for Strategy 3 — you'll usually need to clean up the result manually.

**Compare Changes** — opens a side-by-side diff so you can read both versions before deciding.

### The merge editor view

If VS Code opens the full merge editor (three-panel view), you get:

- **Left panel** — your version (current branch)
- **Right panel** — incoming version
- **Bottom panel** — the result you're building

You can click checkboxes next to individual lines to include or exclude them from the result. Edit the bottom panel directly for full control.

When the result panel looks right, click **Complete Merge** — VS Code stages the file for you.

### One thing to watch

VS Code's "Accept Both Changes" stacks the two versions literally, one after the other. That's rarely what you want. Use it as a starting point, then edit the result panel to remove duplication or fix the order.

---

## Challenge

The Stack Overflown game has two feature branches. Both developers edited the scoring logic in `index.js` — one added high score tracking, the other added a level multiplier to the score calculation. Both changes are valid and both need to ship.

Your job: merge both branches into `main` so that both features work correctly. You'll hit at least one conflict. Resolve it by blending both changes — don't throw either feature away.

No steps. No hints beyond this: read the conflict carefully before you touch anything. Understand what each side is trying to do. Then write the result you'd want if you'd built both features yourself.

When you're done, run `git log --all --graph --oneline` and make sure the history shows both branches merged cleanly into `main`.

---

## Boss Fight 🔴

> Your teammate rage-quit mid-merge. The repo is stuck. Run `git status` — it'll show you the damage. Figure out what happened, finish the merge cleanly, and make sure the game still runs.

Head to `broken-repos/br02-merge-conflict/` and run `setup.sh` to get into the broken state:

```bash
cd broken-repos/br02-merge-conflict
bash setup.sh
```

Then run:

```bash
git status
```

From here, you're on your own. Some things that might help:

- `git status` tells you which files are conflicted and what state the merge is in
- `git diff` shows you what's actually in conflict
- `git merge --abort` is always available if you want to bail and start over
- `git log --all --graph --oneline` shows you what the merge was trying to do

The goal: finish the merge, resolve all conflicts, commit the result, and verify the game files are in a working state. No partial resolutions. No leftover conflict markers.

---

**Difficulty:** 🔴 Intermediate | **Est. time:** 45 min | **Prerequisites:** [m05-branching](../m05-branching/README.md), [m06-merging](../m06-merging/README.md)
