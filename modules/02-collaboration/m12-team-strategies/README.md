# m12-team-strategies

Most teams overcomplicate this. Here's the real story.

## What's this about

Branching strategies aren't Git features — they're team agreements. A branching strategy is just a set of rules your team decides to follow so everyone knows where work happens, what's safe to deploy, and how changes get reviewed. The goal is reducing friction and eliminating the "whose branch is the real one?" problem.

The cheatsheet at [`cheatsheets/branch-strategies.md`](../../../cheatsheets/branch-strategies.md) covers the surface-level comparison. This module goes deeper: the real tradeoffs, the labs, and how to actually choose.

---

## GitHub Flow

The simplest strategy that actually works for most teams. If you don't have a specific reason to use something else, use this.

### The rules (all of them)

1. `main` is always deployable — never commit broken code directly to it
2. All work happens on a branch
3. Branch → commit → push → PR → review → merge → delete branch → done

That's it. No `develop` branch. No release branches. No ceremony.

### What it looks like

```
main  ──●──────────────────────────●──────────────────►
         \                        /
          feature/pause-button   /
           ●──●──●──────────────/
                    PR + review
```

`main` moves forward only through reviewed, approved PRs. Every merge is a deployment candidate.

### Branch naming

Keep it consistent. Common patterns:

```
feature/pause-button        ← new functionality
fix/score-not-updating      ← bug fix
chore/update-gitignore      ← maintenance, no user-facing change
docs/add-contributing-guide ← documentation only
```

### Who it's for

- Small to medium teams (2–20 people)
- Web apps and services that deploy continuously
- Teams where `main` going to production on every merge is fine
- Open source projects with external contributors

### When it breaks down

GitHub Flow assumes you only have one live version at a time. The moment you need to maintain `v1.x` in production while developing `v2.x`, you've outgrown it. You'll find yourself creating long-lived version branches and improvising rules — at which point you've accidentally invented a worse version of Git Flow.

### Lab: implement a feature using GitHub Flow

You're adding a visible "Game Over" overlay to Stack Overflown. Walk through the full GitHub Flow cycle.

**Step 1: Sync main**

```bash
cd sandbox/stack-overflown
git checkout main
git pull origin main   # or just verify you're up to date
git log --oneline -3
```

**Step 2: Branch**

```bash
git checkout -b feature/game-over-overlay
```

**Step 3: Make focused commits**

Open `index.html`. Find the `game-over` div (it already exists). Add a subtitle line inside it:

```html
<div class="game-over" id="gameOver">
  <h2>STACK OVERFLOW!</h2>
  <p class="game-over-subtitle">The stack couldn't hold.</p>
  <p>Final Score: <span id="finalScore">0</span></p>
  <button onclick="location.reload()">Restart</button>
</div>
```

```bash
git add index.html
git commit -m "Add subtitle to game-over overlay"
```

Open `style.css`. Add a style for the subtitle:

```css
.game-over-subtitle {
  color: #858585;
  font-size: 0.95em;
  margin-bottom: 5px;
}
```

```bash
git add style.css
git commit -m "Style game-over subtitle"
```

**Step 4: Push and open a PR**

```bash
git push -u origin feature/game-over-overlay
```

Open a PR on GitHub: `feature/game-over-overlay` → `main`. Write a real description.

**Step 5: Merge and clean up**

After review (even if it's just you reviewing your own work):

```bash
git checkout main
git merge --no-ff feature/game-over-overlay -m "Add game-over overlay subtitle"
git branch --delete feature/game-over-overlay
git push origin --delete feature/game-over-overlay
```

Check the result:

```bash
git log --oneline --graph -5
```

That's GitHub Flow. The whole cycle took one branch, two commits, one PR.

---

## Git Flow

The enterprise-flavored strategy. More branches, more rules, more overhead. Usually overkill — but if you maintain multiple release versions, it earns its keep.

### The branch structure

```
main      ──────────────────────●──────────────────────►  (tagged releases only)
                                ▲
                         release/1.1
                                ▲
develop   ──●──────────────────●──────────────────────►  (integration branch)
             ▲         ▲
             │         │
       feature/A   feature/B
                              hotfix/crash ──► main + develop
```

### The five branch types

| Branch | Lives | Purpose | Branches from | Merges into |
|---|---|---|---|---|
| `main` | Forever | Tagged production releases only | — | — |
| `develop` | Forever | Integration of completed features | `main` (once) | — |
| `feature/*` | Days–weeks | New features | `develop` | `develop` |
| `release/*` | Days | Release stabilisation (bugfixes only) | `develop` | `main` + `develop` |
| `hotfix/*` | Hours | Emergency production fix | `main` | `main` + `develop` |

### The honest take

Git Flow was designed in 2010 for teams shipping boxed software with monthly release cycles. It solves real problems — parallel version maintenance, structured QA gates, clear separation of "in development" and "in production."

It also creates real problems: `develop` becomes a long-lived integration branch that accumulates conflicts, feature branches live too long and diverge, and the merge overhead is significant. Teams that adopt Git Flow for a web app that deploys daily are creating busywork for themselves.

The tell: if your team spends more time managing branches than writing code, the strategy is wrong for your context.

### Who it's for

- Teams with scheduled, versioned releases (mobile apps, desktop software, libraries, APIs with versioned contracts)
- Teams that need to support multiple live versions simultaneously (`v1.x` security patches while `v2.x` is in development)
- Teams with formal QA cycles before release

### When it breaks down

- Small teams where the overhead isn't justified
- Continuous deployment — if you deploy on every merge, `develop` and `release` branches add no value
- Teams without the discipline to keep `develop` clean — it becomes a dumping ground

### Lab: trace a Git Flow cycle

Rather than fully implementing Git Flow (which would take hours), trace through the branch structure with the game as context. This builds the mental model without the overhead.

**Scenario:** Stack Overflown v1.0 is live. You're developing v1.1 with two features: a high score display and a level counter. A crash bug is reported in v1.0.

**Trace the branches:**

```bash
# Start: main is at v1.0
git log --oneline main

# develop branches from main at v1.0
# feature/high-score branches from develop
# feature/level-counter branches from develop

# Both features complete and merge into develop
# release/1.1 branches from develop for final QA
# A minor bug found in QA is fixed directly on release/1.1
# release/1.1 merges into main (tagged v1.1) AND back into develop

# Meanwhile: crash bug reported in v1.0
# hotfix/crash-fix branches from main at v1.0 tag
# Fix is made, hotfix merges into main (tagged v1.0.1) AND into develop
```

Draw this out on paper or in a text file. The key insight: `develop` and `main` are always in sync after each release and hotfix. If they drift, you have a problem.

---

## Trunk-based development

Almost no branches. Everyone commits to `main` (or very short-lived branches that live less than a day). The trunk is always in a releasable state because CI catches anything that isn't.

### What it looks like

```
main  ──●──●──●──●──●──●──●──●──●──●──●──►  (multiple commits per day per developer)
         ▲  ▲     ▲        ▲
         │  │     │        │
       short-lived branches (hours, not days)
       merged same day they're created
```

### How incomplete features ship without breaking things

Feature flags. A feature that isn't ready for users is hidden behind a flag in the code:

```js
if (FEATURES.newScoringSystem) {
  // new code path
} else {
  // existing code path
}
```

The code ships to production. The flag is off. When the feature is ready, flip the flag. No branch needed.

### The honest take

Trunk-based development is the fastest way to ship. It eliminates merge conflicts by making them impossible to accumulate — branches are too short-lived to diverge. It forces small, focused commits. It makes CI the gatekeeper instead of code review alone.

It's also the fastest way to break things if you skip the CI part. Without automated tests running on every commit, you're just committing directly to production with extra steps. The strategy only works if the safety net is real.

### Who it's for

- Experienced teams with strong automated test coverage
- Teams with mature CI/CD pipelines (tests run in minutes, not hours)
- Teams that deploy multiple times per day
- Large engineering organisations (Google, Meta, and others operate this way at scale)

### When it breaks down

- Teams without CI, or where CI is slow and often skipped
- Teams where code review is a compliance requirement (short-lived branches still work, but the "trunk" part is compromised)
- Teams new to Git — the discipline required is high

---

## How to choose

Not a flowchart. Plain English.

**Team of 1–3, shipping fast, one live version?**
→ GitHub Flow. Don't overthink it.

**Multiple live versions, scheduled releases, formal QA?**
→ Git Flow. The overhead is justified.

**Strong CI/CD, experienced team, deploying multiple times a day?**
→ Trunk-based. You've earned it.

**Not sure?**
→ GitHub Flow. It's the right default. Migrate when you have a specific problem it doesn't solve — not before.

The most common mistake is adopting Git Flow because it sounds professional, then spending more time managing branches than shipping features. The second most common mistake is doing trunk-based development without the CI infrastructure to support it.

---

## The meta-rule

> The best branching strategy is the one your whole team actually follows consistently.

A perfect strategy that nobody follows is worse than a simple one everyone uses. If half your team is branching from `develop` and half is branching from `main`, you don't have a strategy — you have chaos with extra steps.

Whatever you choose: write it down, make it visible, and enforce it through PR reviews and branch protection rules, not through hoping everyone remembers.

---

## Challenge

Your team just hired two new developers and your current workflow is "everyone commits to `main`." You're a 5-person team working on Stack Overflown. Propose and document a branching strategy that works for your team size and project.

Write a `WORKFLOW.md` file in `sandbox/stack-overflown/` that explains the rules clearly enough that a new hire could follow them on day one. It should cover: which strategy you chose and why, what branch names look like, how a feature goes from idea to `main`, what happens when a bug is found in production, and what's never allowed (force-pushing `main`, committing directly to `main`, etc.).

No steps. No template. Write the document you'd actually want to hand to a new teammate.

---

## What's next

→ [m13-rebase](../../03-power-tools/m13-rebase/README.md) — once you're working in a team workflow, rebase becomes the tool for keeping your branch history clean before it merges.

---

**Difficulty:** 🟡 Intermediate | **Est. time:** 30 min | **Prerequisites:** [m09-remotes](../m09-remotes/README.md), [m10-workflows](../m10-workflows/README.md), [m11-pull-requests](../m11-pull-requests/README.md)
