# S03: Open Source Contributor

> Here's the situation. Here's what done looks like. Go figure it out.

---

## The situation

Stack Overflown has an open issue:

---

**Issue #42 — Players have no way to pause the game mid-session**

> Opened by: `frustrated-player`
>
> When I'm playing and need to step away, there's no way to pause. The game just keeps running and I lose my progress. I've looked at the controls list and there's no pause option shown.
>
> Expected: some way to pause and resume the game mid-session.
> Actual: no pause mechanism visible to the player.

---

Here's the thing: if you read the source code, you'll find that `togglePause()` already exists in `index.js`. `isPaused` is already a game state variable. The `P` key already calls `togglePause()` in the keyboard handler. The logic is there.

What's missing is everything the player actually sees:

- No pause button in the UI
- No visual overlay when the game is paused — the board just freezes silently
- The only feedback is a small "Paused" text in the status div, which is easy to miss
- `P` for pause isn't listed in the controls section
- There's no way to pause with a mouse/touch — keyboard only

The issue is real. The fix is yours to design.

---

## Your mission

You're a first-time contributor to this project. You found the issue, you've read the code, and you want to fix it. Here's what you need to do — no steps, no hand-holding:

**1. Fork the GitMastery sandbox repo**

Work on your own fork. Don't push directly to the original.

**2. Create a feature branch with a good name**

The branch name should make it obvious what you're working on. `fix-42` is not a good name. `feature/pause-ui` or `fix/pause-button-and-overlay` are better.

**3. Implement a working pause feature**

The logic already exists — your job is to make it visible and usable. At minimum:

- The player should be able to pause and resume without knowing keyboard shortcuts
- When paused, it should be visually obvious the game is paused (not just a small status text)
- The controls list should show how to pause

How you implement it is up to you. A button, an overlay, a modal — your call. Make it feel intentional, not bolted on.

**4. Write a clean commit history**

Your commits will be visible in the PR. They should tell the story of what you built.

Commits like `"fix"`, `"fix2"`, `"ok now it works"`, `"final"` will get your PR sent back. Each commit should be a coherent unit of change with a message that describes what it does.

If you made a mess while figuring things out, clean it up with `git rebase -i` before opening the PR.

**5. Push and open a PR**

Push your branch to your fork and open a PR against the original repo's `main` branch.

**6. Write a PR description that would make sense to a stranger**

The reviewer has not read your code yet. Your description is their first contact with your change. It should answer:

- What was the problem?
- What did you build?
- How does it work?
- How do they test it?

Include `Closes #42` somewhere in the description. GitHub will automatically link and close the issue when the PR is merged.

**7. No merge conflicts with main**

Before opening the PR, make sure your branch is up to date with `main`. If `main` has moved since you branched, rebase or merge it in and resolve any conflicts before the PR is opened — not after.

---

## What "done" looks like

You'll know you're done when all of these are true:

**The game:**
- Has a visible, clickable pause mechanism (button, overlay, or equivalent)
- Shows a clear visual state when paused — not just a status text change
- Lists the pause control in the controls section of the UI
- Resumes correctly when unpaused — pieces fall, timer continues, nothing breaks

**The Git history:**
- `git log --oneline` on your branch shows commits that read like a changelog, not a debugging session
- No commit messages that are just `"fix"`, `"update"`, `"wip"`, or similar
- The number of commits is proportional to the work — don't squash everything into one commit if you made three distinct changes

**The PR:**
- Title is specific and action-oriented
- Description explains what changed, why, and how to test it
- References `Closes #42`
- No unresolved merge conflicts
- The diff is focused — only changes related to the pause feature

---

## Stretch goals

These aren't required. Do them if you want the extra challenge.

**Add a keyboard shortcut label to the UI**

The controls section in `index.html` already lists `←/→`, `↑`, `↓`, `Space`. Add `P` for pause. While you're there, consider whether the controls section is in the right place and readable enough.

**Write a CHANGELOG entry**

Create a `CHANGELOG.md` in the repo root (or add to it if it exists). Add an entry for `v1.1` that describes the pause feature in one line. Format it like a real changelog — date, version, what changed.

**Include a demo description in your PR**

You can't embed a GIF in a PR description without hosting it somewhere, but you can describe what one would show. Write a `## Demo` section in your PR description that describes what a reviewer would see if they watched a 10-second screen recording of the feature working. Be specific enough that they could verify it matches when they test it themselves.

---

## A note on the existing code

Before you write a single line, read these:

- `index.js` — find `isPaused`, `togglePause()`, and the `P` key handler in `handleKeyPress()`
- `index.html` — look at the side panel structure and the existing status div
- `style.css` — look at how `.game-over` is styled; a pause overlay would follow a similar pattern

Understanding what's already there before adding to it is the difference between a PR that gets merged and one that gets sent back with "this duplicates existing logic."

---

## Prerequisites

- [m09-remotes](../../modules/02-collaboration/m09-remotes/README.md) — you need to know how to fork, clone, and push
- [m11-pull-requests](../../modules/02-collaboration/m11-pull-requests/README.md) — you need to know how to write a PR that's worth reviewing

---

**Difficulty:** 🔴 Advanced | **Est. time:** 60–90 min
