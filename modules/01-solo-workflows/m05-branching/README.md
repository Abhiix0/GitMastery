# m05-branching

## What's this about

Committing directly to `main` works fine when you're alone and nothing can go wrong. In practice, things go wrong. Branches give you an isolated space to develop a feature or fix without touching the working version — and a clean way to bring it back in when it's ready.

---

## The concept

A branch is just a lightweight pointer to a commit. Creating one is instant and costs almost nothing. When you branch off `main`, you get your own line of history to work in. `main` stays untouched until you decide to merge.

```
main:    A → B
              ↘
feature:       C → D → E
```

### Merge strategies

There are three common ways to bring a branch back in:

**Fast-forward** — if `main` hasn't moved since you branched, Git just slides the new commits onto it. Clean, linear history.

```
Before:  main: A → B,  feature: A → B → C → D
After:   main: A → B → C → D
```

**Merge commit (`--no-ff`)** — creates a new commit that ties the two branches together. The branch stays visible in the history graph, which is useful for traceability.

```
Before:  main: A → B,  feature: A → B → C → D
After:   main: A → B → C → D → E(merge)
                         ↗
                    feature
```

**Squash** — collapses all the branch commits into one new commit on `main`. Keeps history tidy but loses the individual commit detail.

### Key commands this module

| Command | What it does |
|---|---|
| `git branch <name>` | Create a new branch |
| `git checkout <name>` | Switch to a branch |
| `git branch --list` | List all branches |
| `git log --all --graph --oneline` | See the full history with branches |
| `git merge <branch>` | Merge a branch into the current one (fast-forward by default) |
| `git merge --no-ff <branch> -m "msg"` | Merge with a merge commit |
| `git branch --delete <name>` | Delete a branch label after merging |

> Git 2.23+ has `git switch` as a cleaner alternative to `git checkout` for branch operations. You'll see both in the wild.

---

## Lab

### Activity 1: Branch, commit, and merge (CLI)

Check your current history — it should be linear:

```bash
git log --all --graph --oneline
```

Create a new branch and switch to it:

```bash
git branch fix-incomplete-high-score
git checkout fix-incomplete-high-score
```

Confirm you're on it:

```bash
git branch --list
```

Open `sandbox/stack-overflown/index.js`. On line 41, add a variable for high score:

```js
let highScore = 0;
```

Commit it:

```bash
git add index.js
git commit -m "Add new variable for tracking high score"
```

On line 61, add code to load the stored high score:

```js
// Load high score from localStorage
highScore = parseInt(localStorage.getItem("stackOverflownHighScore")) || 0;
document.getElementById("high-score").textContent = highScore;
```

Commit:

```bash
git add index.js
git commit -m "Add loading of stored high score"
```

Replace the `updateScore` function (around line 313) with:

```js
function updateScore() {
  document.getElementById("score").textContent = score;

  // Update high score if current score exceeds it
  if (score > highScore) {
    highScore = score;
    document.getElementById("high-score").textContent = highScore;
    localStorage.setItem("stackOverflownHighScore", highScore);
  }
}
```

Commit:

```bash
git add index.js
git commit -m "Add logic to keep track of highest score"
```

Check the graph — your feature branch should be 3 commits ahead of `main`:

```bash
git log --all --graph --oneline
```

Switch back to `main` and merge with a merge commit so the branch stays visible:

```bash
git checkout main
git merge --no-ff fix-incomplete-high-score -m "Fix high score tracker"
```

Check the graph again — you'll see the parallel branch that's now merged in.

Clean up the branch label:

```bash
git branch --delete fix-incomplete-high-score
```

### Activity 2: Branch, commit, and merge (VS Code)

Click the branch name in the VS Code status bar (bottom left) and select **Create new branch...**. Name it:

```
add-level-counter
```

Open `index.html`. Around line 21, add a level display element:

```html
<h3>Level</h3>
<div class="score" id="level">1</div>
```

Commit: `Add element to display current level`

Open `index.js`. Around line 42, add level tracking variables:

```js
let level = 1;
let patternsCleared = 0;
```

Commit: `Add variables for level and clear counter`

Replace the `checkPatternMatch` function (around line 273) with:

```js
function checkPatternMatch() {
  for (let startRow = 0; startRow <= ROWS - PATTERN_SIZE; startRow++) {
    for (let startCol = 0; startCol <= COLS - PATTERN_SIZE; startCol++) {
      if (matchesPattern(startRow, startCol)) {
        clearPattern(startRow, startCol);
        score += 100;
        patternsCleared++;
        if (patternsCleared % 5 === 0) {
          level++;
          dropInterval = Math.max(200, 1000 - (level - 1) * 100);
          document.getElementById("level").textContent = level;
        }
        updateScore();
        setNewTargetPattern();
        return;
      }
    }
  }
}
```

Commit: `Add logic to calculate level`

Switch back to `main` via the status bar. Use the `...` menu → **Branch** → **Merge...** to merge `add-level-counter`. Then delete the branch via `...` → **Branch** → **Delete Branch...**.

---

## Challenge

Pick a small improvement to the Stack Overflown game — something you can implement in 2–3 commits. Create a branch with a descriptive name, make the changes across multiple commits (each one focused and well-named), then merge it back into `main` using `--no-ff`. After merging, run `git log --all --graph --oneline` and confirm the branch is visible in the history. Delete the branch label. Do this entirely from the CLI.

---

## What's next

→ [m06-merging](../m06-merging/README.md) — go deeper on merge strategies and what to do when branches diverge.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 35 min | **Skills:** `git branch`, `git checkout`, `git merge`, fast-forward vs no-ff
