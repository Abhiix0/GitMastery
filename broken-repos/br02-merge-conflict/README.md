# br02-merge-conflict

> A repo stuck mid-merge. Your teammate rage-quit. You're cleaning it up.

---

## The scenario

Two developers were working on the Stack Overflown scoring system in parallel:

- **feature-multiplier** — added a score multiplier so points scale with difficulty
- **main** — added high score tracking so the best score persists across games

Both changes touched the same function in `game.js`. When the merge was attempted, Git hit a conflict and stopped. The developer who started the merge left without finishing it. The repo is now stuck in a conflicted state.

Your job is to pick up where they left off.

---

## What state the repo is in

- A merge is in progress (`git status` will confirm this)
- `game.js` contains conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
- Nothing has been staged or committed since the conflict was triggered
- Both branches are intact — no work has been lost

---

## What success looks like

The final `game.js` should have a single `updateScore` function that:

1. Applies the score multiplier (`points * multiplier`)
2. Updates the high score (`highScore = Math.max(score, highScore)`)
3. Updates the display (`display.textContent = score`)
4. Logs the update (`console.log("Score updated:", score)`)

No conflict markers anywhere in the file. A clean commit that completes the merge.

Something like this (exact style is up to you):

```js
function updateScore(points) {
  score = score + (points * multiplier);
  highScore = Math.max(score, highScore);
  display.textContent = score;
  console.log("Score updated:", score);
}
```

---

## How to run

From the `broken-repos/br02-merge-conflict/` directory:

```bash
bash setup.sh
```

This creates a `br02-workspace/` folder with the broken repo inside it. Navigate into it:

```bash
cd br02-workspace
```

Start with:

```bash
git status
```

---

## Verify your solution

Once you think you're done, run the verify script from `broken-repos/br02-merge-conflict/`:

```bash
bash verify.sh
```

It checks:
- No conflict markers left in `game.js`
- The merge was actually committed (not just staged)
- The commit message isn't a default auto-generated merge message

---

## Hints (expand if stuck)

<details>
<summary>Hint 1 — understanding the conflict</summary>

Run `git diff` to see the raw conflict. The `<<<<<<<` block is what `main` had. The `>>>>>>>` block is what `feature-multiplier` had. You need to write a version that combines both.

</details>

<details>
<summary>Hint 2 — what to do with the markers</summary>

Open `game.js` in any editor. Delete all three marker lines (`<<<<<<<`, `=======`, `>>>>>>>`). Edit the code between them until it does what both branches intended. Save.

</details>

<details>
<summary>Hint 3 — finishing the merge</summary>

After editing:

```bash
git add game.js
git commit -m "Resolve merge conflict — combine multiplier and high score"
```

</details>

<details>
<summary>Hint 4 — want to start over?</summary>

```bash
git merge --abort
```

Then re-run `bash setup.sh` from the parent directory to get a fresh broken state.

</details>
