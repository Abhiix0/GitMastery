# S04: The Rogue Commit

> CSI but for code.

---

## The situation

The Stack Overflown game's high score feature is broken. Players are reporting that their high score never updates — it stays at 0 no matter how high they score.

It worked fine at some point. You know this because you can see it in the git log. Somewhere in the last 40 commits, someone introduced a regression. The commit message probably doesn't say "I broke the high score." It never does.

You have a test script. You have `git bisect`. Your job is to find the exact commit that broke it, understand what changed, and fix it.

---

## Setup

Run the scenario setup script to get a repo with 40 commits and a broken high score:

```bash
cd scenarios/s04-the-rogue-commit
bash setup.sh
cd s04-workspace
```

Verify the bug is present:

```bash
bash test.sh
```

You should see `FAIL`. The high score feature is broken at HEAD.

Verify the test passes on an early commit (the setup script will tell you a known-good hash):

```bash
git checkout <known-good-hash>
bash test.sh
# PASS
git checkout main
```

Now you have a confirmed good commit and a confirmed bad commit. You're ready.

---

## Your mission

No steps. Here's what done looks like — work backwards from there.

**1. Identify the exact commit hash that broke the high score feature**

Use `git bisect run bash test.sh` to find it automatically. When bisect finishes, it will print the hash and the commit message. Write it down.

**2. Understand what the bad commit actually changed**

```bash
git show <bad-commit-hash>
```

Read the diff carefully. The bug is in there. It might be subtle — a wrong operator, a missing condition, a variable that got renamed incorrectly. Find the specific line.

**3. Use `git blame` to confirm the line**

Check out `main` again and blame the file:

```bash
git blame score.js
```

Find the line that's wrong. Confirm it points to the same commit hash bisect identified.

**4. Implement the fix**

Fix the bug. The change should be small — you're reverting a specific mistake, not rewriting the feature.

Commit with a message that references the bad commit:

```bash
git commit -m "Fix high score regression (introduced in <bad-commit-hash>)"
```

Use the full hash or at least the first 7 characters. This creates a permanent link in the history between the bug and the fix — anyone reading the log in the future can trace it.

**5. Verify**

```bash
bash test.sh
```

Should print `PASS`.

```bash
git log --oneline -5
```

Should show your fix commit at the top with a proper reference message.

---

## What "done" looks like

- You can state the bad commit hash from memory (or your notes)
- `bash test.sh` prints `PASS` at HEAD
- `git log --oneline` shows a fix commit at the top with a message referencing the bad hash
- `git blame score.js` shows your fix on the corrected line
- No other files were changed — the fix is surgical

---

## Stretch goals

**Write a permanent test.sh that prevents this regression**

The `test.sh` provided tests one specific case. A more robust version would test edge cases: `calculateScore(0)`, `calculateScore(1)`, `calculateScore(10)`. Write a version that covers at least three cases and exits non-zero if any of them fail.

**Document the bisect command for future use**

Add a comment block to the top of `test.sh` explaining how to use it with `git bisect run`:

```bash
# Usage with git bisect:
#   git bisect start
#   git bisect bad HEAD
#   git bisect good <known-good-hash>
#   git bisect run bash test.sh
#   git bisect reset
```

Future you will thank present you.

**Write a post-mortem**

Create a file called `POSTMORTEM.md` in the workspace. Write 3–5 sentences: what the bug was, which commit introduced it, why it wasn't caught, and what would prevent it next time. This is what real incident post-mortems look like, just smaller.

---

## The lesson

`git bisect` turns "something broke somewhere in the last N commits" into a solved problem in O(log N) steps. For 40 commits, that's at most 6 steps. For 1,000 commits, it's at most 10.

The key insight is that you don't need to understand every commit in the range. You just need a reliable test. If the test is automated, bisect does the rest. The investigation that used to take an afternoon takes five minutes.

This is why writing testable code matters. Not just for CI — for debugging.

---

## Prerequisites

- [m14-debugging](../../modules/03-power-tools/m14-debugging/README.md) — you need to be comfortable with `git bisect`, `git blame`, and `git log -S` before this scenario makes sense

---

**Difficulty:** 🔴 Advanced | **Est. time:** 45–60 min
