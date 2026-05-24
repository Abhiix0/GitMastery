# Lab — Hitting and fixing your first conflict

**Working directory:** `sandbox/stack-overflown/`

You're going to manufacture a conflict on purpose so you know exactly what it looks like and how to fix it.

---

## Steps

**1. On main, edit line 1 of `index.js`** — add this as the very first line:
```js
// main branch version
```

**2. Commit it:**
```bash
git add .
git commit -m "Add main branch comment"
```

**3. Create a branch from the commit *before* this one:**
```bash
git checkout -b feature/conflict-test HEAD~1
```
This puts you on a new branch that starts one commit back — before the main branch comment existed.

**4. Edit line 1 of `index.js`** — add this as the very first line:
```js
// feature branch version
```

**5. Commit it:**
```bash
git add .
git commit -m "Add feature branch comment"
```

**6. Switch to main:**
```bash
git checkout main
```

**7. Merge — and watch it fail:**
```bash
git merge feature/conflict-test
```
Git will tell you there's a conflict in `index.js` and stop.

**8. Open `index.js`.** You'll see conflict markers:
```
<<<<<<< HEAD
// main branch version
=======
// feature branch version
>>>>>>> feature/conflict-test
```

- Everything between `<<<<<<< HEAD` and `=======` is what's on main (your current branch).
- Everything between `=======` and `>>>>>>>` is what's coming in from the feature branch.
- Git doesn't know which one you want — that's your call.

**9. Resolve it by keeping both lines.** Edit the file so it looks like:
```js
// main branch version
// feature branch version
```
Delete all three conflict marker lines (`<<<<<<<`, `=======`, `>>>>>>>`). They must not remain in the file.

**10. Stage the resolved file:**
```bash
git add index.js
```

**11. Complete the merge:**
```bash
git commit
```
Git pre-fills a merge commit message. Accept it (save and close the editor).

**12. Check the result:**
```bash
git log --graph --oneline
```
You'll see the two branches converging into the merge commit.

**13. Clean up:**
```bash
git branch -d feature/conflict-test
```

---

## Verification

`git log` shows the merge commit. `index.js` has both comments. No `<<<<<<<` markers anywhere in the file.
