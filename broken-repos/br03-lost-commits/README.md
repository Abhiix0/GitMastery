# br03-lost-commits

> Three commits just vanished from `git log`. They're not gone — but you need to know where to look.

---

## The scenario

Someone panicked and ran `git reset --hard HEAD~3` on the wrong branch. Three commits — high score tracking, level progression, and the combo multiplier — are no longer visible in `git log`.

A junior dev is convinced the work is gone. It isn't. Git doesn't immediately delete commits when you reset — it just stops pointing to them. They're still in the object store, reachable via `git reflog`, for as long as Git's garbage collector hasn't run (usually 30–90 days).

Your job is to find them and bring them back.

---

## What state the repo is in

- `git log` shows only 1 commit: `Setup`
- The last 3 commits (`Add high score tracking`, `Add level progression`, `Add combo multiplier`) are not reachable from `HEAD`
- `game.js` is in its initial state — the high score, level, and combo code is gone from the file
- The commits still exist in Git's object store and are visible in `git reflog`

---

## What success looks like

- `git log` shows all 4 commits in order
- `game.js` contains the combo multiplier code (the most recent state)
- `HEAD` is pointing at the `Add combo multiplier` commit
- Working tree is clean

---

## How to run

From `broken-repos/br03-lost-commits/`:

```bash
bash setup.sh
cd br03-workspace
```

Start with:

```bash
git log
```

Notice what's missing. Then:

```bash
git reflog
```

---

## Verify your solution

From `broken-repos/br03-lost-commits/`:

```bash
bash verify.sh
```

---

## Hints

<details>
<summary>Hint 1 — what git reflog shows</summary>

`git reflog` is a log of everywhere HEAD has pointed, in reverse chronological order. Every commit, checkout, reset, and merge shows up here — even commits that are no longer reachable from any branch.

Look for the commit hashes next to `Add high score tracking`, `Add level progression`, and `Add combo multiplier`.

</details>

<details>
<summary>Hint 2 — how to recover</summary>

Once you find the hash of the `Add combo multiplier` commit in `git reflog`, reset HEAD back to it:

```bash
git reset --hard <commit-hash>
```

This moves `main` forward to that commit, making all 4 commits reachable again.

</details>

<details>
<summary>Hint 3 — alternative approach</summary>

You can also create a new branch pointing to the lost commit, then merge or reset from there:

```bash
git branch recover <commit-hash>
git reset --hard recover
git branch --delete recover
```

Same result, different path.

</details>

<details>
<summary>Hint 4 — the lesson</summary>

`git reset --hard` is one of the few Git commands that can feel truly destructive. But as long as you haven't run `git gc` (garbage collection), the commits are still there. `git reflog` is your safety net for any "I just destroyed my work" moment.

The reflog entries expire after 30–90 days by default. After that, the commits are genuinely gone. This is why pushing to a remote regularly matters — remote copies don't get garbage collected.

</details>
