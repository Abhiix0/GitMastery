# Lab — Stash, .gitignore, and tags

**Working directory:** `sandbox/stack-overflown/`

Three separate tools, one lab. Each one is short.

---

## Part 1 — git stash

**1. Make a change to `index.js`** — add a comment:
```js
// in progress
```
Don't commit it. You're mid-work.

**2. Pretend an urgent fix just came in.** You need a clean working tree to switch context.

**3. Stash your changes:**
```bash
git stash
```
Git saves your uncommitted changes and reverts the working tree to match the last commit.

**4. Confirm it's clean:**
```bash
git status
```
Nothing to commit.

**5. Make the urgent fix** — add a comment to `index.html`:
```html
<!-- emergency fix -->
```

**6. Commit it:**
```bash
git add .
git commit -m "Emergency fix"
```

**7. Restore your in-progress work:**
```bash
git stash pop
```

**8. Check status:**
```bash
git status
```
Your `index.js` change is back, unstaged, right where you left it.

---

## Part 2 — .gitignore

**1. Create a file called `secrets.env`:**
```
API_KEY=abc123
```

**2. Check status:**
```bash
git status
```
Git sees it as an untracked file.

**3. Create a `.gitignore` file in the project root:**
```
*.env
```

**4. Check status again:**
```bash
git status
```
`secrets.env` is gone from the untracked list. Git is now ignoring it.

**5. Commit the `.gitignore`:**
```bash
git add .gitignore
git commit -m "Add gitignore"
```

**6. Try to add the ignored file:**
```bash
git add secrets.env
```
Git refuses. The pattern in `.gitignore` blocks it.

---

## Part 3 — tags

**1. Create a lightweight tag on the current commit:**
```bash
git tag v1.0
```

**2. Check the log:**
```bash
git log --oneline
```
`v1.0` appears next to the commit it points to.

**3. Create an annotated tag** (has a message, author, and date — more like a real release marker):
```bash
git tag -a v1.1 -m "Version 1.1 — added emergency fix"
```

**4. List all tags:**
```bash
git tag
```

**5. Inspect the annotated tag:**
```bash
git show v1.1
```
Shows the tag metadata, then the commit it points to.

---

## Verification

`git stash list` should be empty (you popped it). `git tag` shows both `v1.0` and `v1.1`.
