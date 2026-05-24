# GitMastery 🧠

> Learn Git properly — from zero to dangerous.

[![Stars](https://img.shields.io/github/stars/YOUR_USERNAME/GitMastery?style=flat-square&logo=github)](../../stargazers)
[![Forks](https://img.shields.io/github/forks/YOUR_USERNAME/GitMastery?style=flat-square&logo=github)](../../forks)
[![License](https://img.shields.io/github/license/YOUR_USERNAME/GitMastery?style=flat-square)](./LICENSE)
[![Beginner Friendly](https://img.shields.io/badge/beginner-friendly-4ec9b0?style=flat-square)](./modules/00-foundations/)

---

## Quick Start

```bash
# 1. Fork this repo, then clone your fork
git clone https://github.com/YOUR_USERNAME/GitMastery.git
cd GitMastery

# 2. Pick a starting point (not sure? start at m01)
cd modules/00-foundations/m01-version-control

# 3. Open README.md and start the lab
```

Not sure where to start? Read the [Learner Guide](./LEARNER_GUIDE.md).

---

## Learning Path

16 modules across 4 phases. Each module has a guided lab, a challenge, and a solution.

### Phase 0 — Foundations

| Module | Topic | Difficulty | Est. Time |
|---|---|---|---|
| [m01-version-control](./modules/00-foundations/m01-version-control/) | What Git is, git config, git --version | 🟢 Beginner | 20 min |
| [m02-first-repository](./modules/00-foundations/m02-first-repository/) | git init, add, commit, status | 🟢 Beginner | 25 min |
| [m03-history](./modules/00-foundations/m03-history/) | git log, git checkout, HEAD | 🟢 Beginner | 20 min |
| [m04-diffs](./modules/00-foundations/m04-diffs/) | git diff, git diff --staged | 🟢 Beginner | 25 min |

### Phase 1 — Solo Workflows

| Module | Topic | Difficulty | Est. Time |
|---|---|---|---|
| [m05-branching](./modules/01-solo-workflows/m05-branching/) | git branch, checkout, merge | 🟡 Intermediate | 35 min |
| [m06-merging](./modules/01-solo-workflows/m06-merging/) | FF, no-FF, squash merge | 🟡 Intermediate | 30 min |
| [m07-conflicts](./modules/01-solo-workflows/m07-conflicts/) | Conflict markers, resolution strategies | 🔴 Intermediate | 45 min |
| [m08-stash-tags](./modules/01-solo-workflows/m08-stash-tags/) | git stash, .gitignore, git tag | 🟡 Intermediate | 25 min |

### Phase 2 — Collaboration

| Module | Topic | Difficulty | Est. Time |
|---|---|---|---|
| [m09-remotes](./modules/02-collaboration/m09-remotes/) | clone, push, pull, fetch, remotes | 🟡 Intermediate | 40 min |
| [m10-workflows](./modules/02-collaboration/m10-workflows/) | Team branching workflows | 🟡 Intermediate | 📋 Planned |
| [m11-pull-requests](./modules/02-collaboration/m11-pull-requests/) | PR anatomy, review process | 🟡 Intermediate | 35 min |
| [m12-team-strategies](./modules/02-collaboration/m12-team-strategies/) | GitHub Flow, Git Flow, trunk-based | 🟡 Intermediate | 📋 Planned |

### Phase 3 — Power Tools

| Module | Topic | Difficulty | Est. Time |
|---|---|---|---|
| [m13-rebase](./modules/03-power-tools/m13-rebase/) | git rebase, interactive rebase, conflicts | 🔴 Advanced | 50 min |
| [m14-debugging](./modules/03-power-tools/m14-debugging/) | git bisect, blame, log -S | 🔴 Advanced | 40 min |
| [m15-automation](./modules/03-power-tools/m15-automation/) | Git hooks, aliases, scripting | 🔴 Advanced | 📋 Planned |
| [m16-advanced](./modules/03-power-tools/m16-advanced/) | Internals, worktrees, submodules | 🔴 Advanced | 📋 Planned |

---

## Scenarios

Real-world situations. No step-by-step instructions — just a situation, a goal, and your tools.

| Scenario | What happens | Difficulty | Est. Time |
|---|---|---|---|
| [S01: Rescue the Release](./scenarios/s01-rescue-the-release/) | A release branch is broken. Ship it anyway. | 🔴 Advanced | 📋 Planned |
| [S02: The Great Merge War](./scenarios/s02-the-great-merge-war/) | Three developers, three conflicting branches. Untangle it. | 🔴 Advanced | 📋 Planned |
| [S03: Open Source Contributor](./scenarios/s03-open-source-pr/) | Fork → implement → PR → review → merge. End to end. | 🔴 Advanced | 60–90 min |
| [S04: The Rogue Commit](./scenarios/s04-the-rogue-commit/) | High score feature broke 40 commits ago. Find the culprit. | 🔴 Advanced | 45–60 min |

---

## Broken Repos

Pre-broken repositories. Run `setup.sh`, read `git status`, figure it out.

| Scenario | What's broken | Fix involves |
|---|---|---|
| [br01-detached-head](./broken-repos/br01-detached-head/) | HEAD is floating — commits will vanish if you switch away | `git checkout -b`, `git reflog` |
| [br02-merge-conflict](./broken-repos/br02-merge-conflict/) | A merge was abandoned mid-conflict | Resolving conflict markers, `git merge --abort` |
| [br03-lost-commits](./broken-repos/br03-lost-commits/) | `git reset --hard` wiped 3 commits | `git reflog`, `git reset --hard <hash>` |
| [br04-rebase-gone-wrong](./broken-repos/br04-rebase-gone-wrong/) | A rebase was abandoned with conflicts in the working tree | `git rebase --continue` or `git rebase --abort` |

---

## Cheatsheets

Quick references for when you know what you want but can't remember the exact command.

| Cheatsheet | What's in it |
|---|---|
| [git-basics.md](./cheatsheets/git-basics.md) | Every common command, grouped by task, one line each |
| [branch-strategies.md](./cheatsheets/branch-strategies.md) | GitHub Flow vs Git Flow vs Trunk-based — when to use each |
| [emergency-commands.md](./cheatsheets/emergency-commands.md) | "I broke something" → command to fix it |

---

## The Sandbox Game

The learning exercises use a real browser game called **Stack Overflown** — a dev-themed puzzle game where you match falling blocks to error patterns before the stack overflows.

The game lives in [`sandbox/stack-overflown/`](./sandbox/stack-overflown/). You'll be making real changes to real code throughout the modules.

Open `sandbox/stack-overflown/index.html` in a browser to play it.

---

## Contributing

Want to add a module, fix an error, or improve an exercise?

Read [CONTRIBUTING.md](./CONTRIBUTING.md) first — it covers folder structure, naming conventions, how to open a PR, and the tone guide.

See [ROADMAP.md](./ROADMAP.md) for what's planned and what's available to claim.

---

## Learner resources

- [LEARNER_GUIDE.md](./LEARNER_GUIDE.md) — how to use this repo, how exercises work, how to verify your solutions
- [ROADMAP.md](./ROADMAP.md) — all 16 modules and their current status

---

&copy; 2025 GitMastery &bull; [MIT License](./LICENSE) &bull; made for learners, by learners
