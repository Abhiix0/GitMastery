# Branch Strategies Cheatsheet

Three strategies used by real teams. Pick the one that fits your team size, release cadence, and tolerance for complexity.

---

## 1. GitHub Flow

**The simplest strategy that works.** One long-lived branch (`main`), everything else is a short-lived feature branch that gets merged via PR.

### How it works

```
main ──────────────────────────────────────────────► (always deployable)
        │                    │
        ▼                    ▼
  feature/login        fix/score-bug
  (branch off main)    (branch off main)
        │                    │
        └──── PR ────────────┘
              merge to main
```

### The cycle

1. Branch off `main`: `git checkout -b feature/my-thing`
2. Commit your work
3. Open a PR against `main`
4. Review, approve, merge
5. Delete the branch
6. Deploy `main`

### When to use it

- Web apps and services that deploy continuously
- Small to medium teams
- When you want simplicity over ceremony
- When `main` is always production-ready

### Pros

- Easy to understand — one rule: `main` is always deployable
- Fast feedback loop — changes ship quickly
- Low overhead — no release branches, no develop branch
- Works well with CI/CD pipelines

### Cons

- Requires discipline: every merge to `main` must be production-ready
- No built-in staging area for grouping releases
- Can be chaotic with many contributors merging frequently
- Feature flags often needed to hide incomplete work

---

## 2. Git Flow

**A structured strategy for versioned releases.** Two permanent branches (`main` and `develop`), plus short-lived feature, release, and hotfix branches.

### How it works

```
main     ──────────────────────────────────────────► (tagged releases only)
              ▲                    ▲
              │ release/1.0        │ hotfix/crash-fix
develop  ──────────────────────────────────────────► (integration branch)
              ▲         ▲
              │         │
        feature/A   feature/B
```

### Branch types

| Branch | Purpose | Branches from | Merges into |
|---|---|---|---|
| `main` | Production releases only | — | — |
| `develop` | Integration of completed features | `main` | — |
| `feature/*` | New features | `develop` | `develop` |
| `release/*` | Release preparation (bugfixes only) | `develop` | `main` + `develop` |
| `hotfix/*` | Emergency production fixes | `main` | `main` + `develop` |

### When to use it

- Software with explicit versioned releases (mobile apps, desktop software, libraries)
- Teams that need a clear separation between "in development" and "in production"
- When you need to support multiple versions simultaneously

### Pros

- Clear structure — everyone knows where each type of change goes
- Release branches allow final stabilisation without blocking new feature work
- Hotfixes can ship without pulling in unfinished features
- Good audit trail for what shipped in each version

### Cons

- High overhead — lots of branches, lots of merges
- Merge conflicts accumulate if feature branches live too long
- Overkill for teams deploying continuously
- `develop` can become a long-lived integration mess if not managed carefully

---

## 3. Trunk-Based Development

**Everyone commits to one branch, frequently.** Feature branches exist but are extremely short-lived (hours to a day, not weeks). The trunk (`main`) is always in a releasable state.

### How it works

```
main  ──●──●──●──●──●──●──●──●──●──●──►  (commits land here constantly)
         ▲     ▲        ▲
         │     │        │
       feat  feat     feat
       (< 1 day)    (< 1 day)
```

### The rules

- Branches live for hours, not days
- Every commit to `main` must pass CI
- Incomplete features are hidden behind feature flags, not long-lived branches
- Developers pull from `main` and push to `main` multiple times per day

### When to use it

- High-velocity teams with strong CI/CD
- Large engineering organisations (Google, Facebook, and others use this)
- When you want to eliminate merge conflicts by making them impossible to accumulate
- When deployment is fully automated

### Pros

- Merge conflicts are rare — branches are too short-lived to diverge significantly
- Continuous integration is real, not just a name
- Forces small, focused commits
- Fast feedback — broken code is caught within hours, not at merge time

### Cons

- Requires mature CI/CD infrastructure
- Feature flags add complexity to the codebase
- Needs strong team discipline — a bad commit affects everyone immediately
- Harder to manage for teams new to Git

---

## Choosing a strategy

| Situation | Recommended strategy |
|---|---|
| Solo project or small team, continuous deployment | GitHub Flow |
| App with versioned releases (v1.0, v2.0) | Git Flow |
| Large team, mature CI/CD, high deployment frequency | Trunk-based |
| Open source project with external contributors | GitHub Flow |
| Mobile app with App Store release cycles | Git Flow |
| Microservices with independent deployment | GitHub Flow or Trunk-based |

The honest answer: most teams start with GitHub Flow and add complexity only when they have a specific problem it doesn't solve. Git Flow is often adopted prematurely. Trunk-based development is aspirational for most teams until the CI infrastructure is solid.
