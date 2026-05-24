# Solution — m12

> **Try the challenge yourself first.** Writing this out in your own words is the exercise.

---

## The right strategy: Git Flow

GitHub Flow assumes you ship continuously from main. That breaks down when you have:
- Monthly release cycles (you need to stabilize a release without blocking new work)
- Multiple live versions (you need to patch v1.x while v2.x is in development)

Git Flow was designed for exactly this. Here's what a solid `TEAM_WORKFLOW.md` looks like:

---

```markdown
# Team Workflow

## Branching Strategy: Git Flow

### Permanent branches

**`main`**
Always reflects the current production release. Only receives merges from
`release/*` and `hotfix/*` branches. Never commit directly to main.
Every merge into main gets a version tag (e.g. v1.3.0).

**`develop`**
The integration branch. All completed features land here first.
This is what gets stabilized into a release. Never commit directly to develop.

---

### Temporary branches

**`feature/*`** (branches off: `develop`, merges back into: `develop`)
One branch per feature. Name it after what it does: `feature/dark-mode`,
`feature/leaderboard`. When the feature is done, open a PR into `develop`.
Delete the branch after merge.

**`release/*`** (branches off: `develop`, merges into: `main` AND `develop`)
Created when develop has everything planned for the next release.
Name it after the version: `release/1.3.0`.
Only bug fixes go on this branch — no new features.
When stable, merge into main (tag it) and back into develop (to capture the fixes).
Delete after merge.

**`hotfix/*`** (branches off: `main`, merges into: `main` AND `develop`)
For urgent production fixes that can't wait for the next release cycle.
Name it: `hotfix/1.2.1-fix-score-crash`.
Fix the bug, merge into main (tag it as a patch release), merge into develop too.
Delete after merge.

---

### Feature lifecycle

1. Pull latest develop: `git checkout develop && git pull`
2. Branch: `git checkout -b feature/your-feature`
3. Work in commits with meaningful messages
4. Push and open a PR into `develop`
5. Get reviewed, address comments in new commits
6. Squash and merge into develop
7. Delete the branch

---

### Release lifecycle

1. Branch off develop: `git checkout -b release/1.3.0`
2. Test, fix bugs on the release branch (no new features)
3. Merge into main: `git checkout main && git merge --no-ff release/1.3.0`
4. Tag: `git tag -a v1.3.0 -m "Release 1.3.0"`
5. Merge back into develop: `git checkout develop && git merge --no-ff release/1.3.0`
6. Delete the release branch

---

### Hotfix lifecycle

1. Branch off main: `git checkout -b hotfix/1.2.1-fix-score-crash main`
2. Fix the bug, commit it
3. Merge into main: `git checkout main && git merge --no-ff hotfix/1.2.1-fix-score-crash`
4. Tag: `git tag -a v1.2.1 -m "Hotfix: fix score crash on level 5"`
5. Merge into develop too: `git checkout develop && git merge --no-ff hotfix/1.2.1-fix-score-crash`
6. Delete the hotfix branch

---

### Version tagging

We use semantic versioning: `vMAJOR.MINOR.PATCH`
- MAJOR: breaking changes
- MINOR: new features, backwards compatible
- PATCH: bug fixes only

Every merge into main gets a tag. No exceptions.
```

---

## Why not GitHub Flow here

GitHub Flow works when:
- You deploy continuously (every merge to main goes live)
- You only maintain one version at a time

It breaks down when:
- You need a stabilization period before release (release branches solve this)
- You need to patch an old version while new work is in progress (hotfix branches solve this)
- Multiple versions are live simultaneously (main + develop separation solves this)

Git Flow adds overhead — more branches, more merges. That overhead is worth it at this team size and release cadence. For a two-person team shipping daily, it's overkill. Match the strategy to the actual constraints.
