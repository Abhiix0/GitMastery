# S01: Rescue the Release

> Production ships in 2 hours. The release branch has a bug. There's a half-finished hotfix on another branch. Figure it out.

---

## The situation

Your team was preparing v2.0 of Stack Overflown.

A `release/v2` branch was cut from `main` three days ago. Since then, someone merged a change that broke the game — the score display shows `NaN` instead of the actual score. The commit message says `"Refactor score calculation"`. It does not say `"I introduced a bug."` It never does.

There's also a hotfix sitting on `hotfix/score-crash` — a null check that prevents a crash when `score` is undefined. It was written, committed, and then forgotten. It was never merged anywhere.

You have two hours before the release goes out.

Run `setup.sh` to get the broken repo, then read on.

```bash
bash setup.sh
cd s01-workspace
git log --all --graph --oneline
```

---

## The repo state

After setup, the history looks like this:

```
main:             A ── B ── C
                       \         \
release/v2:             D(bug)    \
                                   \
hotfix/score-crash:                 E(fix)
```

- `main` has three clean commits
- `release/v2` branched from `main` and has one commit that introduced the NaN bug
- `hotfix/score-crash` branched from `main` and has one commit with a crash fix that was never merged

The bug: `src/index.js` on `release/v2` multiplies the score by `undefined`, which produces `NaN`. Open `src/index.html` in a browser to see it.

The hotfix: `hotfix/score-crash` adds a null check to `updateScore`. It's a separate fix from the NaN bug — you need both.

---

## Your mission

No steps. Here's what needs to happen — figure out the order yourself.

**1. Investigate `release/v2`**

Understand what broke and why. Use `git log`, `git diff`, `git show`. Find the exact line that's wrong before you touch anything.

**2. Fix the NaN bug on `release/v2`**

The fix is small. One line. Commit it with a message that makes clear what you fixed and why.

**3. Bring in the crash fix from `hotfix/score-crash`**

You don't want to merge the whole `hotfix/score-crash` branch — it might have other things on it in a real scenario. Take just the fix commit. The tool for this is in [m16-advanced](../../modules/03-power-tools/m16-advanced/README.md).

**4. Verify `release/v2` is clean**

Open `src/index.html` in a browser. The score display should show `0` on load, not `NaN`. If you add calls to `updateScore` in the console, the number should increment correctly.

**5. Tag the final state as `v2.0`**

Use an annotated tag. The message should describe what's in this release.

```bash
git tag -a v2.0 -m "your message here"
```

**6. Merge `release/v2` into `main`**

`main` should end up with everything from `release/v2`, including your fixes and the cherry-picked hotfix.

---

## What "done" looks like

- `git log --oneline release/v2` shows a clean, readable history — no `"fix"`, `"oops"`, or `"try again"` commits
- `git tag` shows `v2.0`
- `git show v2.0` shows your annotated tag message and the commit it points to
- `git log --oneline main` includes the release commits
- Opening `src/index.html` in a browser shows `0` in the score display, not `NaN`
- `git log --all --graph --oneline` shows a coherent history — you can explain every commit

---

## Hints

<details>
<summary>Hint 1 — finding the bug</summary>

```bash
git checkout release/v2
git log --oneline
git show HEAD          # inspect the most recent commit
git diff main release/v2 -- src/index.js   # see exactly what changed
```

Look at the `updateScore` function. One operand is wrong.

</details>

<details>
<summary>Hint 2 — fixing the NaN bug</summary>

Open `src/index.js` on `release/v2`. The line:

```js
document.getElementById("score").textContent = score * undefined;
```

should be:

```js
document.getElementById("score").textContent = score;
```

Fix it, stage it, commit it with a message that references what went wrong.

</details>

<details>
<summary>Hint 3 — bringing in the hotfix</summary>

You need `git cherry-pick`. Find the commit hash of the fix on `hotfix/score-crash`:

```bash
git log --oneline hotfix/score-crash
```

Then, while on `release/v2`:

```bash
git cherry-pick <hash>
```

</details>

<details>
<summary>Hint 4 — tagging and merging</summary>

Tag after your fixes are committed on `release/v2`:

```bash
git tag -a v2.0 -m "Stack Overflown v2.0 — fix NaN score display, add crash guard"
```

Then merge into `main`:

```bash
git checkout main
git merge --no-ff release/v2 -m "Release v2.0"
```

</details>

---

## Stretch goals

**Write a RELEASE_NOTES.md**

Create `RELEASE_NOTES.md` in the repo root. Write one paragraph describing what changed in v2.0 — what was fixed, what was added, and what a player would notice. Write it for a human, not a changelog parser.

**Make the tag message count**

An annotated tag message that says `"v2.0"` is useless. Write one that someone reading the history in six months would actually find helpful: what's in this release, what was fixed, what's the state of the game.

---

## Prerequisites

- [m06-merging](../../modules/01-solo-workflows/m06-merging/README.md) — you need to know how to merge cleanly
- [m08-stash-tags](../../modules/01-solo-workflows/m08-stash-tags/README.md) — annotated tags
- [m11-pull-requests](../../modules/02-collaboration/m11-pull-requests/README.md) — understanding release workflows
- [m16-advanced](../../modules/03-power-tools/m16-advanced/README.md) — cherry-pick is the key tool here

---

**Difficulty:** 🔴 Advanced | **Est. time:** 45–60 min
