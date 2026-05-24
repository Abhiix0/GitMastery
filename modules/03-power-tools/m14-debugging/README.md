# m14-debugging

Git is the world's best debugging tool and nobody talks about it enough.

Most people use Git to save work and collaborate. That's fine. But Git also stores the complete history of every change ever made to your codebase — who changed what, when, and why. When something breaks and you don't know where to start, that history is a crime scene. These tools are how you read it.

---

## The tools

### `git blame` — who touched this line?

`git blame <file>` annotates every line of a file with the commit hash, author, and date that last changed it. When you find a bug on a specific line, blame tells you exactly which commit introduced it and who wrote it.

```bash
git blame index.js
```

Output looks like:

```
a3f1c2d (Alex Chen  2025-03-14 11:22:01 +0000  42) let score = 0;
b7e9d1a (Sam Rivera 2025-03-18 09:15:44 +0000  43) let highScore = 0;
a3f1c2d (Alex Chen  2025-03-14 11:22:01 +0000  44) let gameOver = false;
```

Each line: `hash (author date line-number) content`

Useful flags:

| Flag | What it does |
|---|---|
| `git blame -L 40,55 index.js` | Blame only lines 40–55 |
| `git blame -w index.js` | Ignore whitespace changes |
| `git blame --follow index.js` | Follow the file through renames |
| `git show <hash>` | See the full commit that changed a line |

`git blame` tells you the commit. `git show <hash>` tells you the full story of that commit — what else changed, what the message said, what the diff looked like.

---

### `git log -S` — when was this code added?

`git log -S "search term"` finds every commit where the number of occurrences of `"search term"` changed — meaning it was added or removed. This is called a "pickaxe" search.

```bash
# Find when "highScore" was first added to the codebase
git log -S "highScore" --oneline

# Same search, show the actual diff
git log -S "highScore" --oneline -p

# Limit to a specific file
git log -S "highScore" --oneline -- index.js
```

`git log -G` is the regex variant — it searches the diff content rather than counting occurrences:

```bash
git log -G "high[Ss]core" --oneline
```

Use `-S` when you want to find where something was introduced or removed. Use `-G` when you need a pattern match.

---

### `git log --follow` — track a file through renames

Regular `git log <file>` stops at the point where the file was renamed. `--follow` traces it back through renames:

```bash
git log --follow --oneline src/index.js
```

Useful when a file started life as `game.js`, got moved to `src/game.js`, then renamed to `src/index.js`. Without `--follow`, you only see history from the last rename.

---

### `git bisect` — binary search for the bad commit

`git bisect` is the most powerful debugging tool in Git. You tell it one good commit (where the bug didn't exist) and one bad commit (where it does). Git checks out the midpoint. You test. You tell Git whether that commit is good or bad. Git halves the search space again. Repeat until it identifies the exact commit that introduced the bug.

For a range of 1,000 commits, bisect finds the culprit in at most 10 steps.

```bash
git bisect start
git bisect bad                    # current commit is broken
git bisect good <commit-hash>     # this older commit was fine

# Git checks out the midpoint
# You test manually, then:
git bisect good    # or: git bisect bad

# Repeat until Git says:
# "abc1234 is the first bad commit"

git bisect reset   # return to HEAD when done
```

**Automated bisect with a test script:**

If you have a script that exits `0` for pass and non-zero for fail, bisect can run it automatically:

```bash
git bisect start
git bisect bad HEAD
git bisect good <known-good-hash>
git bisect run ./test.sh
```

Git runs `test.sh` at each midpoint, uses the exit code to classify good/bad, and finds the culprit without any manual input. This is the fast path for any bug that can be tested programmatically.

---

## Lab 1 — git blame

Make sure you have a commit history in `sandbox/stack-overflown/` from the earlier modules. If you've been following along, you should have at least 5–10 commits there.

### Task 1: Annotate index.js

```bash
cd sandbox/stack-overflown
git blame index.js
```

Read the output. Notice:
- Lines that were part of the initial commit all share the same hash
- Lines added in later commits (comments, the high score variable if you added it) show different hashes and authors

### Task 2: Blame a specific range

The `updateScore` function is near the bottom of `index.js`. Find its line number, then blame just that section:

```bash
git blame -L 285,300 index.js
```

Adjust the line numbers to match where `updateScore` lives in your file.

### Task 3: Follow a commit to its full context

Pick any hash from the blame output. Run:

```bash
git show <hash>
```

You'll see the full commit: message, author, date, and the complete diff. This is how you go from "this line looks wrong" to "here's everything that changed in that commit."

### Task 4: Find the commit that introduced `highScore`

If you added a `highScore` variable during the m05 branching lab, find the exact commit that introduced it:

```bash
git log -S "highScore" --oneline -- index.js
```

Then show that commit in full:

```bash
git show <hash>
```

You should see the exact line where `highScore` was declared, in context with everything else that changed in that commit.

---

## Lab 2 — git log -S

### Task: find when "multiplier" entered the codebase

If you worked through the br03-lost-commits scenario, your `sandbox/stack-overflown/` history may include commits that added a combo multiplier. Search for it:

```bash
git log -S "multiplier" --oneline
```

If your sandbox history doesn't have it, try searching for something you know you added — a comment, a variable name, a function:

```bash
git log -S "updateScore" --oneline
git log -S "dropInterval" --oneline
```

### Task: see the diff alongside the results

Add `-p` to see the actual change at each matching commit:

```bash
git log -S "multiplier" --oneline -p
```

The diff shows exactly where the term was added (green `+` lines) or removed (red `-` lines). This is how you confirm you found the right commit before digging deeper.

### Task: search across all branches

By default `git log` only searches the current branch. To search everything:

```bash
git log -S "multiplier" --all --oneline
```

---

## Lab 3 — git bisect

You'll set up a controlled scenario where a bug was introduced somewhere in a sequence of commits, then use bisect to find it automatically.

### Step 1: Create a repo with a known bug

Run the bisect setup script from this module's lab folder:

```bash
cd modules/03-power-tools/m14-debugging/lab
bash bisect-setup.sh
cd bisect-workspace
```

This creates a repo with 10 commits. One of them introduced a bug in `score.js` — the `calculateScore` function returns the wrong value. A `test.sh` script is provided that prints `PASS` or `FAIL` and exits accordingly.

### Step 2: Verify the test script works

```bash
bash test.sh
```

You should see `FAIL` — the current HEAD is broken.

Check an early commit manually to confirm it was once good:

```bash
git log --oneline
```

Copy the hash of the first commit, then:

```bash
git stash   # save any uncommitted state
git checkout <first-commit-hash>
bash test.sh
```

You should see `PASS`. Come back to HEAD:

```bash
git checkout main
git stash pop
```

### Step 3: Run bisect manually

```bash
git bisect start
git bisect bad                        # HEAD is broken
git bisect good <first-commit-hash>   # first commit was fine
```

Git checks out the midpoint commit. Run the test:

```bash
bash test.sh
```

Tell Git the result:

```bash
git bisect good   # or: git bisect bad
```

Repeat. After 3–4 steps, Git will say something like:

```
abc1234 is the first bad commit
commit abc1234
Author: ...
Date:   ...

    Add score multiplier
```

That's your culprit.

```bash
git bisect reset   # return to HEAD
```

### Step 4: Automate it

Run the whole thing in one command:

```bash
git bisect start
git bisect bad HEAD
git bisect good <first-commit-hash>
git bisect run bash test.sh
```

Git runs `test.sh` at each midpoint automatically. Same result, zero manual steps. This is the pattern you'll use in S04.

```bash
git bisect reset
```

### Step 5: Understand the bad commit

Once bisect identifies the commit hash, inspect it:

```bash
git show <bad-commit-hash>
```

Read the diff. Understand what changed. Now you know exactly what to fix and why.

---

## Challenge

You have a repo where `updateScore` stopped working correctly at some point in the last 8 commits. You don't know which one. You have a `test.sh` that exits `0` if the score increments correctly and `1` if it doesn't.

Your job:

1. Use `git bisect run` to find the exact commit that broke it — no manual stepping
2. Use `git blame` to identify the specific line in `updateScore` that's wrong
3. Use `git log -S` to find any other commits that touched the same term
4. Fix the bug and commit with a message that references the bad commit hash: `"Fix score regression (introduced in <hash>)"`

No steps. The tools are all in this module.

---

## Scenario hook

This module feeds directly into **S04: The Rogue Commit**.

In S04, the high score feature is broken somewhere in a 40-commit history. You have a test script. You have `git bisect`. The scenario is everything in this module applied to a real investigation — find the commit, understand the change, implement the fix.

Go there when you're comfortable running `git bisect run` without thinking about it.

→ [S04: The Rogue Commit](../../../scenarios/s04-the-rogue-commit/README.md)

---

## What's next

→ [m15-automation](../m15-automation/README.md) — Git hooks, aliases, and scripting your workflow so the boring parts run themselves.

---

**Difficulty:** 🔴 Advanced | **Est. time:** 40 min | **Prerequisites:** [m03-history](../../00-foundations/m03-history/README.md), [m13-rebase](../m13-rebase/README.md)
