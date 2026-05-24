# Solution — m11

> **Try the challenge yourself first.**

---

## PR description matters

A PR without context forces reviewers to reverse-engineer your intent from the diff. That's slow and annoying. A good description takes two minutes to write and saves everyone else ten.

Minimum useful PR description:
- What changed (one sentence)
- Why it changed (one sentence, if not obvious)
- How to test it (specific steps, not "it works")

Example for the high score feature:
```
## What
Adds a persistent high score tracker to the game. The top score is saved to
localStorage and displayed above the game board.

## How to test
1. Open index.html in a browser
2. Play a game and let it end
3. Refresh the page — your high score should still be there
4. Beat it — the display should update
```

---

## Addressing review comments with new commits

When a reviewer leaves a comment, you fix it in a new commit — you don't amend the existing one.

Why: amending rewrites history. If you force-push an amended commit, the reviewer's comment now points to a commit that no longer exists in the same form. The review thread breaks.

New commits keep the timeline intact. The reviewer can see exactly what changed in response to their feedback.

```bash
# After leaving a review comment on your own PR:
# Make the fix locally
git add .
git commit -m "Address review: use localStorage.getItem with fallback"
git push origin feature/high-score
```

The new commit shows up in the PR automatically.

---

## Squash and merge vs Create a merge commit

| Option | What it does | When to use |
|---|---|---|
| **Squash and merge** | Collapses all PR commits into one on main | Messy branch history, or you want main to stay clean |
| **Create a merge commit** | Preserves all commits + adds a merge commit | When individual commits have value and you want them on main |
| **Rebase and merge** | Replays commits on top of main, no merge commit | Linear history, clean commits |

For most feature work: squash and merge. The branch history lives in the PR for reference, and main stays readable.
