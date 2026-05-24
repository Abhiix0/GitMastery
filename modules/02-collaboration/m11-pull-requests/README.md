# m11-pull-requests

PRs aren't bureaucracy — they're how you communicate intent.

A lot of developers treat pull requests as a hoop to jump through before merging. That's the wrong frame. A PR is a conversation: "here's what I changed, here's why, here's how to verify it — does this look right to you?" Done well, it's the most useful artifact a team produces. Done badly, it's noise that slows everyone down.

This module covers what makes a PR good, how the review process actually works, and how to open one that people will actually want to review.

---

## What a PR actually is

First, the important clarification: **pull requests are not a Git feature.** Git doesn't know what a PR is. Git only knows about commits, branches, and merges.

A pull request is a GitHub (or GitLab, Bitbucket, etc.) feature built on top of Git branches. When you open a PR, you're saying:

> "I have a branch with some commits on it. I'd like to merge it into another branch. Before we do that, let's look at the diff together and talk about it."

That's it. Under the hood, merging a PR is just `git merge`. The PR is the conversation wrapper around that merge — the place to review the diff, leave comments, request changes, and document why the change was made.

This means everything you've learned about branches applies directly. A PR is just a branch with a discussion attached.

### The distributed angle

When you're working on a fork (a repo you don't have write access to), a PR is also how you propose changes to someone else's repo. You push to your fork, open a PR against the original, and the maintainer decides whether to merge it. Same mechanism, different ownership model.

---

## Anatomy of a good PR

### Title

The title should be specific and action-oriented. It should complete the sentence: "If merged, this PR will..."

| ❌ Bad | ✅ Good |
|---|---|
| `fix` | `Fix score not resetting on game restart` |
| `updates` | `Add pause button to game controls` |
| `WIP` | `[WIP] Refactor scoring logic — not ready for review` |
| `changes to index.js` | `Extract updateScore into separate scoring module` |

One test: can someone read the title in a list of 20 PRs and know exactly what it does? If not, rewrite it.

### Description

The description is where you give reviewers the context they need to evaluate your change. A good description answers three questions:

1. **What changed?** — a brief summary of the diff in plain English
2. **Why?** — the motivation. What problem does this solve? What was wrong before?
3. **How to test it?** — what should a reviewer do to verify it works?

**Bad description:**

```
Fixed the thing we talked about. Also cleaned up some stuff.
```

A reviewer has no idea what "the thing" is, what was cleaned up, or how to verify anything.

**Good description:**

```
## What changed
Added a visible "Restart" button to the game UI. Previously the only
way to restart was to reload the page — not obvious to new players.

## Why
Players were getting stuck on the game-over screen with no clear
next action. This adds a button that calls location.reload().

## How to test
1. Open index.html in a browser
2. Let the stack overflow (or hard-drop until it does)
3. Confirm the "Restart" button appears on the game-over screen
4. Click it — the game should reset to the initial state

## Notes
No JS changes needed — the button uses the existing onclick handler
already in the HTML. Styling matches the existing button in style.css.
```

A reviewer can now understand the change, evaluate whether the approach is right, and verify it works — all without asking you a single question.

### Size and focus

**One concern per PR.** This is the rule that makes everything else easier.

A PR that adds a feature, fixes two bugs, and refactors a module is hard to review, hard to revert if something goes wrong, and hard to understand in the history six months later.

If you find yourself writing "also..." in the description, that's a sign you have two PRs.

Practical size guide:
- **Small** (< 200 lines changed): easy to review thoroughly, merge quickly
- **Medium** (200–500 lines): fine for a self-contained feature, needs a good description
- **Large** (500+ lines): consider breaking it up; if you can't, the description needs to be excellent

---

## The review process

### Leaving comments

**Line comments** — click the `+` icon next to a specific line in the diff to leave a comment on that exact line. Use these for specific feedback: "this variable name is confusing", "this condition looks inverted", "missing a null check here".

**General comments** — use the main comment box at the bottom of the PR for overall feedback that doesn't belong to a specific line: "the approach looks good but I'd like to see a test", "have you considered X?", "LGTM".

### Review states

When you submit a review, you choose one of three states:

- **Comment** — leave feedback without blocking the merge. Use for suggestions, questions, or observations that aren't blockers.
- **Request changes** — block the merge until the author addresses your feedback. Use when something needs to be fixed before this ships.
- **Approve** — signal that you're happy with the change and it can be merged.

Most teams require at least one approval before merging. Some require two. The number matters less than the quality of the review.

### The author's job

When you receive review feedback, your job is to respond to every comment — not just push more commits silently.

For each comment, either:
- **Make the change** and reply "Done" (or explain what you changed and why)
- **Disagree** and explain why — "I considered this but went with X because Y"
- **Ask for clarification** if the comment isn't clear

Pushing commits without responding to comments leaves reviewers guessing whether you saw their feedback. It's the fastest way to slow down a review cycle.

### Resolving conversations

Once a comment thread is addressed, mark it as **Resolved**. This collapses the thread and signals to the reviewer that you've handled it. The reviewer can re-open it if they disagree with the resolution.

A PR is ready to merge when all conversations are resolved and the required approvals are in.

---

## Lab — Open a real PR

You'll add a visible "Restart" button to the Stack Overflown game, open a PR, review it, address feedback, and merge it.

### Step 1: Set up your branch

If you're working on your own fork from m09, clone it and navigate in. Otherwise, use your local `sandbox/stack-overflown/` repo:

```bash
cd sandbox/stack-overflown
git checkout main
git pull origin main   # make sure you're up to date
```

Create a feature branch:

```bash
git checkout -b feature/restart-button
```

### Step 2: Add the restart button

Open `index.html`. Find the game-over div (around line 50 — it has `id="gameOver"`). Add a restart button inside it if one doesn't already exist, or improve the existing one:

```html
<div class="game-over" id="gameOver">
  <h2>STACK OVERFLOW!</h2>
  <p>Your stack reached the ceiling</p>
  <p>Final Score: <span id="finalScore">0</span></p>
  <button id="restartBtn" onclick="location.reload()">
    ↩ Restart Game
  </button>
</div>
```

Open `index.html` in a browser and verify the game-over screen looks right. You don't need to add any JS — `location.reload()` handles the restart.

### Step 3: Commit and push

```bash
git add index.html
git commit -m "Add restart button to game-over screen"
git push -u origin feature/restart-button
```

### Step 4: Open the PR on GitHub

1. Go to your repo on GitHub — you'll see a banner offering to open a PR for your recently pushed branch. Click it. Or go to **Pull requests → New pull request** and select `feature/restart-button` as the head branch.

2. Write a proper title:
   ```
   Add restart button to game-over screen
   ```

3. Write a description using the template from earlier — what changed, why, how to test it. Be specific. Pretend a stranger is reviewing this.

4. Click **Create pull request**.

### Step 5: Review your own PR

On the PR page, go to the **Files changed** tab. Find the line where you added the button text `↩ Restart Game`.

Click the `+` icon on that line and leave a comment:

```
Should this say "Play Again" instead of "Restart Game"? 
Feels more game-like.
```

Click **Start a review**, then **Submit review** with the **Request changes** option.

Your PR is now blocked — it has an unresolved change request.

### Step 6: Address the feedback

Back in your terminal:

```bash
git checkout feature/restart-button
```

Open `index.html` and update the button text:

```html
<button id="restartBtn" onclick="location.reload()">
  ↩ Play Again
</button>
```

Commit the change:

```bash
git add index.html
git commit -m "Update restart button text to Play Again"
git push
```

### Step 7: Respond and resolve

Back on the PR on GitHub:

1. Reply to your own comment: `"Good call — updated to 'Play Again' in the latest commit."`
2. Click **Resolve conversation**
3. Go to the **Files changed** tab and verify the button text is now `Play Again`
4. Submit a new review — this time **Approve**

### Step 8: Merge

Click **Merge pull request** → **Confirm merge**.

Go back to your local repo:

```bash
git checkout main
git pull origin main
git log --oneline -5
```

Your two commits (`Add restart button` and `Update restart button text`) are now on `main`. The branch can be deleted:

```bash
git branch --delete feature/restart-button
git push origin --delete feature/restart-button
```

---

## Scenario hook

This module is preparation for **S03: Open Source Contributor**.

In that scenario, you'll contribute a real feature to the Stack Overflown game end-to-end: fork the repo, identify an issue, implement a fix, write a proper PR description, respond to review feedback, and get it merged. Everything in this module — the PR structure, the review process, the commit discipline — applies directly.

If the lab above felt mechanical, S03 is where it becomes real. The difference is that someone else will be reviewing your PR, and the feedback won't be scripted.

→ [S03: Open Source Contributor](../../../scenarios/s03-open-source-pr/README.md)

---

## What's next

→ [m12-team-strategies](../m12-team-strategies/README.md) — how teams structure their branches, who merges what, and how to avoid stepping on each other.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 35 min | **Prerequisites:** [m09-remotes](../m09-remotes/README.md), [m05-branching](../../01-solo-workflows/m05-branching/README.md)
