# m04-diffs

## What's this about

Before you commit something, it's worth knowing exactly what you're committing. `git diff` shows you the precise lines that changed — added, removed, or modified. This module covers reading diffs and knowing when to use which variant.

---

## The concept

Git uses a simple notation to show changes:

```diff
+ this line was added
- this line was removed
```

Green `+` lines are additions. Red `-` lines are deletions. A modified line shows up as a removal of the old version and an addition of the new one.

There are three states your changes can be in, and a different `diff` command for each:

```
Working Directory  →  Staging Area  →  Repository
      ↑                    ↑
  git diff            git diff --staged
```

- `git diff` — what's changed in your working directory that isn't staged yet
- `git diff --staged` — what's staged and ready to commit, compared to the last commit
- `git diff HEAD~1` — what changed between the current commit and the one before it

Once you stage a file, `git diff` stops showing it (working dir now matches staging). Use `git diff --staged` to see what's queued up.

### Key commands this module

| Command | What it does |
|---|---|
| `git diff` | Unstaged changes vs last commit |
| `git diff <file>` | Diff for a specific file only |
| `git diff --staged` | Staged changes vs last commit |
| `git diff HEAD~1` | Current commit vs previous commit |

---

## Lab

### Activity 1: View diffs in the CLI

Open `sandbox/stack-overflown/index.html`. Find the score section (around line 20) and replace it with this:

```html
<div class="info-section">
  <h3>Current Score</h3>
  <div class="score" id="score">0</div>
  <h3>High Score</h3>
  <div class="high-score" id="high-score">0</div>
</div>
```

This makes three kinds of changes at once: modifies a label, adds new elements, and removes the status div.

See the diff before staging:

```bash
git diff index.html
```

You'll see the old lines in red and new lines in green.

Stage the file:

```bash
git add index.html
```

Run `git diff index.html` again — nothing shows up. The working directory now matches staging.

See what's staged:

```bash
git diff --staged index.html
```

Same changes, but now you're comparing staging vs the last commit. Commit it:

```bash
git commit -m "Add element for showing high score"
```

### Activity 2: View diffs in VS Code

Open `sandbox/stack-overflown/patterns.js`. Find the `Null Pointer` pattern (around line 3) and replace it with:

```js
{
  name: "Null Pointer",
  pattern: [
    [0, 1, 1, 1, 0],
    [0, 1, 0, 1, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0],
  ],
},
```

In the **Source Control** tab, the file will show an `M` (modified). Double-click it to open the diff view — old on the left, new on the right.

Stage the file (click the `+` next to it). Notice the diff view updates — you can no longer edit in it because staging is locked.

Commit with:

```
Make null pointer pattern easier to complete
```

---

## Challenge

Make two separate changes to the Stack Overflown game files — one to `index.html` and one to `style.css`. Stage only the `index.html` change. Then use `git diff` and `git diff --staged` to confirm you can see each change in the right place. Commit the staged change, then stage and commit the CSS change separately. End result: two clean, focused commits. No bundling unrelated changes.

---

## What's next

→ [m05-branching](../../01-solo-workflows/m05-branching/README.md) — stop committing directly to main and start using branches like a pro.

---

**Difficulty:** 🟢 Beginner | **Est. time:** 25 min | **Skills:** `git diff`, `git diff --staged`
