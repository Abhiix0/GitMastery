# Lab — Open and review a PR

**Working directory:** `sandbox/stack-overflown/`

> **Requires the GitHub repo from the m09 lab.**

---

## Steps

**1. Create a feature branch:**
```bash
git checkout -b feature/pause-button
```

**2. Add a pause button to `index.html`** — put it somewhere visible in the game UI:
```html
<button id="pause-btn" onclick="togglePause()">⏸ Pause</button>
```

**3. Add the toggle function to `index.js`:**
```js
let isPaused = false;

function togglePause() {
  isPaused = !isPaused;
  document.getElementById('pause-btn').textContent = isPaused ? '▶ Resume' : '⏸ Pause';
}
```

**4. Commit:**
```bash
git add .
git commit -m "Add pause/resume button to game"
```

**5. Push the branch:**
```bash
git push origin feature/pause-button
```

**6. Go to GitHub.** You'll see a yellow banner: "feature/pause-button had recent pushes — Compare & pull request." Click it.

**7. Fill in the PR:**
- **Title:** `Add pause/resume button`
- **Description:**
  ```
  Adds a pause button to the game UI. Players can click it to pause and resume.

  To test: open index.html in a browser, start the game, click Pause — the game
  should freeze and the button should change to Resume.
  ```

**8. Click **Create pull request**.**

**9. Review your own PR:**
- Click the **Files changed** tab
- Find the button HTML you added
- Click the `+` icon on that line to add a comment
- Write something like: "Should this button be disabled before the game starts?"
- Click **Start a review** → **Submit review**

**10. Resolve the comment:**
- Go back to the **Conversation** tab
- Find your comment → click **Resolve conversation**

**11. Merge the PR:**
- Click **Squash and merge**
- Confirm the commit message looks clean
- Click **Confirm squash and merge**

**12. Delete the branch on GitHub** — click the "Delete branch" button that appears after merging.

**13. Sync locally:**
```bash
git checkout main
git pull
git branch -d feature/pause-button
```

---

## Verification

`git log --oneline` on main shows the squashed commit. `git branch -a` shows no `feature/pause-button` anywhere.
