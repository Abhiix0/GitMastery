# S02: The Great Merge War

> Three developers all started features at the same time from the same commit. Now they all need to be on main. None of them conflict cleanly.

---

## The situation

Stack Overflown has three simultaneous feature branches, all cut from the same base commit, all modifying `index.js`:

- **feature/high-score** — Developer A added high score tracking. `updateScore` now checks if the current score beats the high score and updates a `#high-score` element. `startGame` resets the display.

- **feature/level-counter** — Developer B added level progression. `checkPatternMatch` now increments a level every 5 patterns cleared. `startGame` resets the level. Also added a `console.log` to `updateScore` for debugging (which they forgot to remove).

- **feature/pause-button** — Developer C added pause/resume. `checkPatternMatch` now returns early if paused. A `togglePause` function flips the state and updates a button. `startGame` resets the pause state.

All three branches modified `index.js`. All three modified `index.html`. None of them knew what the others were doing.

Your job: get all three features onto `main`, conflicts resolved, game working.

```bash
bash setup.sh
cd s02-workspace
git log --all --graph --oneline
```

---

## What you're dealing with

After setup, the history looks like this:

```
main:                  A (base)
                      /|\
                     / | \
feature/high-score: B  |  \
                       |   \
feature/level-counter: C    \
                             \
feature/pause-button:         D
```

Three branches, one common ancestor, zero merges. Every merge you attempt will produce conflicts in `index.js` because all three branches rewrote the same functions.

The conflicts aren't random noise — each one represents a real decision: whose version of `updateScore` do you keep? How do you combine the high score check, the console.log, and the pause guard into one function that does all three things?

---

## Your mission

No steps. Here's what needs to happen — figure out the order and approach yourself.

**1. Understand what each branch actually changed**

Before you merge anything, read the code. Use `git diff` to compare each branch against `main`:

```bash
git diff main feature/high-score -- src/index.js
git diff main feature/level-counter -- src/index.js
git diff main feature/pause-button -- src/index.js
```

Understand what each developer was trying to do. The conflicts will make more sense once you know the intent behind each change.

**2. Merge all three branches into main**

Pick an order. The first merge will be clean (no conflicts — `main` hasn't changed). The second will conflict. The third will conflict more. Each conflict is a decision point: how do these two versions of the same function coexist?

**3. Resolve all conflicts so all three features work together**

The final `index.js` needs to contain all of this:
- `highScore` variable and high score display update in `updateScore`
- `level` variable and level increment in `checkPatternMatch`
- `isPaused` variable, early return in `checkPatternMatch`, and `togglePause` function
- `startGame` that resets all three: score, level, and pause state

The final `index.html` needs all four elements: `#score`, `#high-score`, `#level`, and `#pause-btn`.

One thing to decide: the `console.log("Score:", score)` from `feature/level-counter`. It's a debugging artifact. Keep it or drop it — but make the decision consciously, not by accident.

**4. Verify the game runs**

Open `src/index.html` in a browser. Call the functions from the browser console to verify:

```js
startGame()           // should reset everything
checkPatternMatch()   // should increment score and patterns
checkPatternMatch()   // again
togglePause()         // should show "Resume" on the button
checkPatternMatch()   // should NOT increment (paused)
togglePause()         // should show "Pause" again
checkPatternMatch()   // should increment again
```

If any of those behave unexpectedly, a conflict was resolved incorrectly.

**5. End with a clean git log --graph**

```bash
git log --all --graph --oneline
```

All three branches should show as merged into `main`. Every merge commit should have a message that describes what was merged, not just `"Merge branch 'feature/x'"`.

---

## Rules

**No losing any feature.** All three must be present and working in the final `main`. Resolving a conflict by deleting one side is not a resolution — it's a loss.

**No "just delete the conflicting code."** Read what each side is doing before you touch anything. If you don't understand why a line is there, find out before removing it.

**Every merge commit needs a meaningful message.** `"Merge feature/high-score into main"` is fine. `"Merge branch 'feature/high-score'"` (the default) is not — it tells you nothing about what the merge involved or what conflicts were resolved.

---

## What "done" looks like

- `git log --all --graph --oneline` shows all three branches merged into `main`
- `src/index.js` contains all three features: high score, level counter, pause
- `src/index.html` contains all four elements: `#score`, `#high-score`, `#level`, `#pause-btn`
- No conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) anywhere in any file
- Opening `src/index.html` in a browser and calling the functions manually produces correct behaviour
- Every merge commit has a message you wrote, not a default

---

## Hints

<details>
<summary>Hint 1 — merge order strategy</summary>

The first merge is always clean. The second and third will conflict. A good order:

1. Merge the branch with the most self-contained changes first (least likely to conflict with the others)
2. Merge the branch that touches the most shared code last (you'll have the most context by then)

There's no single right order — but merging `feature/pause-button` last is reasonable because its changes to `checkPatternMatch` (the early return) need to coexist with `feature/level-counter`'s changes to the same function.

</details>

<details>
<summary>Hint 2 — what the final updateScore should look like</summary>

All three branches modified `updateScore`. The final version needs to:
1. Increment `score` by `points`
2. Update `#score` display
3. Check and update `highScore` if beaten (from `feature/high-score`)

The `console.log` from `feature/level-counter` is optional — your call.

```js
function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;

  if (score > highScore) {
    highScore = score;
    document.getElementById("high-score").textContent = highScore;
  }
}
```

</details>

<details>
<summary>Hint 3 — what the final checkPatternMatch should look like</summary>

Two branches modified `checkPatternMatch`. The final version needs to:
1. Return early if paused (from `feature/pause-button`)
2. Increment `patternsCleared`
3. Call `updateScore(100)`
4. Check if level should increment (from `feature/level-counter`)

```js
function checkPatternMatch() {
  if (isPaused) return;
  patternsCleared++;
  updateScore(100);

  if (patternsCleared % 5 === 0) {
    level++;
    document.getElementById("level").textContent = level;
  }
}
```

</details>

<details>
<summary>Hint 4 — what the final startGame should look like</summary>

Three branches modified `startGame`. The final version needs to reset everything:

```js
function startGame() {
  score = 0;
  patternsCleared = 0;
  level = 1;
  isPaused = false;
  document.getElementById("score").textContent = 0;
  document.getElementById("high-score").textContent = highScore;
  document.getElementById("level").textContent = 1;
  document.getElementById("pause-btn").textContent = "Pause";
}
```

Note: `highScore` is intentionally not reset — high scores persist across games.

</details>

---

## Stretch goals

**Rebase instead of merge**

Instead of merge commits, rebase all three branches onto `main` before merging. The end result should be a linear history with no merge commits. You'll still hit conflicts — they just happen during rebase instead of merge.

```bash
git checkout feature/high-score
git rebase main
# resolve conflicts
git checkout main
git merge --ff-only feature/high-score   # fast-forward, no merge commit
```

Repeat for the other two branches. The final `git log --oneline` should be a straight line.

**Write a MERGE_NOTES.md**

Create `MERGE_NOTES.md` in the repo root. Document: which conflicts you hit, what each side was trying to do, and how you resolved them. This is the kind of document that saves the next person who touches this code an hour of archaeology.

---

## Prerequisites

- [m07-conflicts](../../modules/01-solo-workflows/m07-conflicts/README.md) — you need to be comfortable resolving conflicts before this scenario makes sense
- [m09-remotes](../../modules/02-collaboration/m09-remotes/README.md) — understanding how branches relate
- [m10-workflows](../../modules/02-collaboration/m10-workflows/README.md) — the daily rhythm this scenario breaks

---

**Difficulty:** 🔴 Advanced | **Est. time:** 60–90 min
