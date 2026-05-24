# br04-rebase-gone-wrong

> A rebase started, hit a conflict, and was abandoned. The repo is stuck. You're cleaning it up.

---

## The scenario

A developer started rebasing a feature branch onto `main`. The rebase hit a conflict on the first commit — both branches changed the same `config` line in `app.js`. Instead of resolving it, they walked away. The terminal is closed. The repo is mid-rebase with an unresolved conflict sitting in the working tree.

You've been handed the keyboard. Figure out what state it's in, decide whether to finish the rebase or abort it, and get the repo back to a clean state.

---

## What state the repo is in

- A rebase is in progress (`.git/rebase-merge/` exists)
- `app.js` contains conflict markers — the file is not valid JavaScript
- The rebase stopped at the first feature commit (`Add pauseGame function`)
- The second feature commit (`Add resumeGame function`) hasn't been replayed yet
- `git status` will tell you exactly what's happening if you read it carefully

---

## What success looks like

**Option A — finish the rebase:**
- Resolve the conflict in `app.js` (decide which `config` value to keep, or blend them)
- `git add app.js && git rebase --continue`
- Resolve any further conflicts on subsequent commits
- End state: feature branch rebased onto `main`, linear history, both `pauseGame` and `resumeGame` present

**Option B — abort the rebase:**
- `git rebase --abort`
- End state: repo returns to exactly where it was before the rebase started, feature branch intact, no rebase in progress

Either option is valid. The goal is a clean repo — no rebase in progress, no conflict markers, clean working tree.

---

## How to run

From `broken-repos/br04-rebase-gone-wrong/`:

```bash
bash setup.sh
cd br04-workspace
```

Start with:

```bash
git status
```

Read every line. Then:

```bash
git log --all --graph --oneline
```

Understand what the rebase was trying to do before you touch anything.

---

## Verify your solution

From `broken-repos/br04-rebase-gone-wrong/`:

```bash
bash verify.sh
```

The verify script accepts both outcomes (finish or abort) as valid. It checks that the repo is in a clean state, not which path you took.

---

## Hints

<details>
<summary>Hint 1 — reading the state</summary>

`git status` during a broken rebase shows:

- Which branch is being rebased
- Which commit is currently being applied
- Which files are conflicted

`cat .git/rebase-merge/head-name` shows the branch being rebased.
`cat .git/rebase-merge/onto` shows the commit it's being rebased onto.

</details>

<details>
<summary>Hint 2 — resolving the conflict and continuing</summary>

Open `app.js`. Find the conflict markers. Decide which `config` value makes sense (or write a new one). Remove all three marker lines. Save.

Then:

```bash
git add app.js
git rebase --continue
```

Git will open an editor for the commit message. Save and close it. If there are more commits to replay, the rebase continues. If another conflict appears, repeat the process.

</details>

<details>
<summary>Hint 3 — aborting cleanly</summary>

If you just want the repo back to a known good state without finishing the rebase:

```bash
git rebase --abort
```

This undoes everything the rebase did and returns the branch to its pre-rebase state. No data is lost. The feature branch is intact.

</details>

<details>
<summary>Hint 4 — what to do if you're really stuck</summary>

If the rebase is in a state you can't reason about, abort it and start fresh:

```bash
git rebase --abort
git log --all --graph --oneline   # understand the current state
git rebase main                   # start the rebase again cleanly
```

A clean abort followed by a fresh rebase is always better than pushing through a confused state.

</details>
