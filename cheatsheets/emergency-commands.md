# I broke something — help

Calm down. Git almost never permanently deletes anything. Find your situation below.

---

## "I committed to the wrong branch"

You meant to commit to `feature/x` but committed to `main` instead.

```bash
# Step 1: copy the commit to the right branch
git checkout feature/x
git cherry-pick main

# Step 2: remove it from main
git checkout main
git reset --hard HEAD~1
```

`cherry-pick` replays the commit onto your current branch. `reset --hard HEAD~1` removes the last commit from `main` and discards it.

> ⚠️ If you've already pushed the commit to a shared remote, `reset --hard` + force push will rewrite history for everyone. See "I force-pushed" below instead.

---

## "I need to undo my last commit (keep the changes)"

You committed too early. You want the changes back in your working directory.

```bash
git reset --soft HEAD~1    # keep changes staged
# or
git reset HEAD~1           # keep changes unstaged (default: --mixed)
```

Your files are untouched. The commit is gone. Stage and recommit when ready.

---

## "I need to undo my last commit (throw away the changes)"

You committed something wrong and want it completely gone.

```bash
git reset --hard HEAD~1
```

> ⚠️ Destructive. The commit and all its changes are discarded from your working directory. Not recoverable via normal means — use `git reflog` within 30–90 days if you change your mind.

If the commit is already pushed to a shared branch, use `git revert` instead:

```bash
git revert HEAD    # creates a new commit that undoes the last one (safe for shared branches)
```

---

## "I accidentally deleted a branch"

You ran `git branch -D my-branch` and immediately regretted it.

```bash
# Find the commit the branch was pointing to
git reflog

# Look for the last commit on that branch, then recreate the branch
git checkout -b my-branch <hash>
```

`git reflog` shows everywhere HEAD has been. Find the hash of the last commit on the deleted branch and point a new branch at it.

> ⚠️ This only works if Git's garbage collector hasn't run yet (usually safe for 30–90 days). If you pushed the branch to a remote, you can also restore it from there: `git checkout -b my-branch origin/my-branch`.

---

## "I'm in detached HEAD state"

You checked out a commit hash directly and now HEAD is floating.

```bash
# Option A: create a branch here to save any commits you've made
git checkout -b rescue-branch

# Option B: if you haven't made any commits and just want to go back
git checkout main
```

Detached HEAD isn't broken — it just means HEAD points to a commit instead of a branch. Any commits you make here are unreachable once you switch away unless you attach them to a branch first.

If you already switched away and lost commits:

```bash
git reflog                          # find the lost commit hash
git checkout -b rescue <hash>       # recreate a branch pointing to it
```

---

## "I have a merge conflict I want to just abandon"

You started a merge, hit conflicts, and want to go back to before the merge started.

```bash
git merge --abort
```

The repo returns to its pre-merge state. All conflict markers are gone. Nothing is lost.

Same applies to a rebase in progress:

```bash
git rebase --abort
```

---

## "I force-pushed and now everyone's history is broken"

You ran `git push --force` on a shared branch and rewrote history that others had already pulled.

There's no single command that fixes this — it requires coordination.

**For each affected teammate:**

```bash
# They need to reset their local branch to match the remote
git fetch origin
git checkout <affected-branch>
git reset --hard origin/<affected-branch>
```

> ⚠️ This discards any local commits they made on top of the old history. If they have unpushed work, they need to cherry-pick it onto the new history first.

**Prevention:** use `git push --force-with-lease` instead of `--force`. It refuses to push if the remote has commits you haven't seen, which prevents overwriting someone else's work.

```bash
git push --force-with-lease    # safer force push
```

---

## "My repo is in a weird state and I don't know why"

Start here. Always.

```bash
git status
```

Read every line. Git tells you exactly what operation is in progress (merge, rebase, cherry-pick), which files are conflicted, and what commands are available to continue or abort.

If that's not enough:

```bash
git log --all --oneline --graph    # see the full picture of all branches
git reflog                          # see everywhere HEAD has been recently
```

Between `git status`, `git log --all --graph`, and `git reflog`, you can diagnose almost any broken state. The repo is almost never as broken as it feels.

---

## Quick reference

| Problem | Command | Destructive? |
|---|---|---|
| Committed to wrong branch | `cherry-pick` + `reset --hard` | ⚠️ Yes (reset) |
| Undo last commit, keep changes | `git reset --soft HEAD~1` | No |
| Undo last commit, discard changes | `git reset --hard HEAD~1` | ⚠️ Yes |
| Undo a pushed commit safely | `git revert HEAD` | No |
| Recover deleted branch | `git reflog` + `git checkout -b` | No |
| Escape detached HEAD | `git checkout -b <name>` | No |
| Abandon a merge | `git merge --abort` | No |
| Abandon a rebase | `git rebase --abort` | No |
| Diagnose anything | `git status` | No |
