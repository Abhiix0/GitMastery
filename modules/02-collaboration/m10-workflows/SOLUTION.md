# Solution — m10

> **Try the challenge yourself first.**

---

## Answer

```bash
git checkout main

# Branch 1: sound toggle (touches index.js and index.html)
git checkout -b feature/sound-toggle
# Commit 1: add isMuted variable to index.js
git add . && git commit -m "Add isMuted state variable"
# Commit 2: add mute button to index.html
git add . && git commit -m "Add mute/unmute button to UI"
git checkout main

# Branch 2: dark mode (touches style.css and index.html)
git checkout -b feature/dark-mode
# Commit 1: add dark mode CSS variables to style.css
git add . && git commit -m "Add dark mode color variables to CSS"
# Commit 2: add dark mode toggle button to index.html
git add . && git commit -m "Add dark mode toggle button to UI"
git checkout main

# Merge first branch
git merge feature/sound-toggle

# Merge second branch
git merge feature/dark-mode
```

## If there's a conflict

Both branches touched `index.html` (adding buttons). If they added them in the same spot, you'll get a conflict. Open the file, find the markers, and keep both buttons:

```html
<button onclick="toggleMute()">🔇 Mute</button>
<button onclick="toggleDarkMode()">🌙 Dark Mode</button>
```

Then:
```bash
git add index.html
git commit
```

## Recommendation

Merge the simpler branch first. The first merge is always clean (nothing to conflict with). The second merge is where conflicts can appear — and by then you've already got one feature safely on main, so you're only dealing with one set of changes at a time.

## Clean up

```bash
git branch -d feature/sound-toggle
git branch -d feature/dark-mode
```
