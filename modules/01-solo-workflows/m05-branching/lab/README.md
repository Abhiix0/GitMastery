# Lab — Creating and switching branches

**Working directory:** `sandbox/stack-overflown/`

---

## Steps

**1. Make sure you're on main:**
```bash
git checkout main
```

**2. Check what branches exist:**
```bash
git branch
```
Just `main` for now. The asterisk marks the current branch.

**3. Create a new branch and switch to it:**
```bash
git checkout -b feature/add-pause-button
```
This is shorthand for `git branch feature/add-pause-button` + `git checkout feature/add-pause-button`.

**4. Confirm you're on it:**
```bash
git branch
```
Asterisk should be on `feature/add-pause-button`.

**5. Make a change — open `index.js` and add this comment near the top:**
```js
// TODO: implement pause
```

**6. Commit it:**
```bash
git add .
git commit -m "Add pause button placeholder"
```

**7. Switch back to main:**
```bash
git checkout main
```

**8. Open `index.js`.** The comment is gone. That change lives on the feature branch — main doesn't know about it yet.

**9. Switch back:**
```bash
git checkout feature/add-pause-button
```
The comment is back. Branches are fully isolated.

**10. See the divergence:**
```bash
git log --all --graph --oneline
```
You'll see `feature/add-pause-button` is one commit ahead of `main`.

**11. Switch to main and merge:**
```bash
git checkout main
git merge feature/add-pause-button
```
This is a fast-forward merge — main just moves its pointer forward to the branch tip. No merge commit needed because there's no divergence.

**12. Check the log:**
```bash
git log --oneline
```
The commit is now on main.

**13. Delete the branch pointer (the work is already on main):**
```bash
git branch -d feature/add-pause-button
```

---

## Verification

`git log --oneline` shows the pause button commit on main. `git branch` shows only `main`.
