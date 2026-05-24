# Lab — The daily Git rhythm

**Working directory:** `sandbox/stack-overflown/`

This lab simulates the actual loop you'll run every day on a real project: pull, branch, work, handle drift, merge, push, clean up.

---

## Steps

**1. Start from an up-to-date main:**
```bash
git checkout main
git pull origin main
```
Always do this before creating a new branch. You want to branch off the latest, not something stale.

**2. Create your feature branch:**
```bash
git checkout -b feature/game-instructions
```

**3. Add keyboard instructions to `index.html`** — somewhere visible in the HTML, add:
```html
<!-- Instructions: arrow keys to move, space to hard drop -->
```

**4. Commit:**
```bash
git add .
git commit -m "Add keyboard instructions comment to HTML"
```

**5. Add a second small commit** — add a `<noscript>` fallback inside `<body>`:
```html
<noscript>This game requires JavaScript to run.</noscript>
```

```bash
git add .
git commit -m "Add no-JavaScript fallback message"
```

**6. Push your branch to the remote:**
```bash
git push origin feature/game-instructions
```

**7. Simulate main moving while you were working:**
```bash
git checkout main
```
Edit `style.css` — change any color value (background, border, anything).
```bash
git add .
git commit -m "Tweak color palette"
git checkout feature/game-instructions
```

**8. Bring your branch up to date with main:**
```bash
git merge main
```
Different files were touched, so this should be a clean merge. Your branch now has the color change too.

**9. Confirm the history looks right:**
```bash
git log --graph --oneline
```

**10. Merge your feature into main:**
```bash
git checkout main
git merge feature/game-instructions
```

**11. Push main:**
```bash
git push origin main
```

**12. Delete the branch — locally and on the remote:**
```bash
git branch -d feature/game-instructions
git push origin --delete feature/game-instructions
```

---

## Verification

`git log --oneline` shows both the color palette commit and the instructions commits on main. `git branch -a` shows no `feature/game-instructions` branch anywhere.
