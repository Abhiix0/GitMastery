# br01-detached-head

> You checked out a commit directly. Now HEAD is floating in space. Anything you commit here will vanish unless you act.

---

## The scenario

You were exploring the project history and ran `git checkout` on a commit hash instead of a branch name. Git obliged — and quietly detached HEAD from any branch.

In detached HEAD state, you can look around, make changes, even commit. But those commits aren't attached to any branch. The moment you switch away, Git loses track of them. They'll eventually be garbage collected and gone for good.

You've been asked to make a hotfix while you're here. The problem: if you commit it and then switch back to `main`, the commit disappears.

Your job is to make the hotfix commit and then rescue it before it's lost.

---

## What state the repo is in

- HEAD is pointing directly at a commit hash, not a branch
- You're two commits behind `main` (the header and footer commits don't exist from your current view)
- Any commits you make here are "dangling" — not reachable from any branch

---

## What success looks like

- A file called `hotfix.html` exists and is committed
- HEAD is attached to a branch (not detached)
- That branch contains the `hotfix.html` commit
- All 3 original commits (`Initial commit`, `Add header`, `Add footer`) still exist and are reachable

---

## How to run

From `broken-repos/br01-detached-head/`:

```bash
bash setup.sh
cd br01-workspace
```

Start with:

```bash
git status
```

Read the whole output. Git tells you exactly what state you're in and what your options are.

---

## Verify your solution

From `broken-repos/br01-detached-head/`:

```bash
bash verify.sh
```

---

## Hints

<details>
<summary>Hint 1 — what detached HEAD actually means</summary>

Normally, HEAD points to a branch name (like `main`), and the branch name points to a commit. When you commit, the branch moves forward automatically.

In detached HEAD, HEAD points directly to a commit hash. When you commit, HEAD moves forward — but no branch follows it. Switch away and the commit becomes unreachable.

</details>

<details>
<summary>Hint 2 — making the hotfix commit</summary>

You can commit normally in detached HEAD state. Create `hotfix.html`, add some content, then:

```bash
git add hotfix.html
git commit -m "Add hotfix"
```

The commit exists. Now you need to save it.

</details>

<details>
<summary>Hint 3 — rescuing the commit</summary>

Create a branch pointing to your current position before you move anywhere:

```bash
git checkout -b hotfix-branch
```

Now HEAD is attached to `hotfix-branch`, which points to your hotfix commit. Switch to `main` and the commit is safe — it's reachable from `hotfix-branch`.

</details>

<details>
<summary>Hint 4 — if you already switched away</summary>

If you switched back to `main` before creating a branch, the commit is still there — just unreachable from normal `git log`. Use `git reflog` to find it:

```bash
git reflog
```

Find the commit hash of your hotfix, then:

```bash
git branch hotfix-rescue <commit-hash>
```

</details>
