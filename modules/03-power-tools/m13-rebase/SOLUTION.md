# Solution — m13

> **Try the challenge yourself first.**

---

## Setup

```bash
git checkout -b feature/cleanup-practice
git commit --allow-empty -m "WIP: start score system"
git commit --allow-empty -m "wip"
git commit --allow-empty -m "Add score tracking"
git commit --allow-empty -m "fix"
git commit --allow-empty -m "fix again"
git commit --allow-empty -m "Add combo multiplier"
git commit --allow-empty -m "tweak"
```

## Before

```bash
git log --oneline
# 7 messy commits
```

## Interactive rebase

```bash
git rebase -i HEAD~7
```

Editor opens:
```
pick a1 WIP: start score system
pick a2 wip
pick a3 Add score tracking
pick a4 fix
pick a5 fix again
pick a6 Add combo multiplier
pick a7 tweak
```

Edit to:
```
pick a1 WIP: start score system
s    a2 wip
pick a3 Add score tracking
s    a4 fix
s    a5 fix again
pick a6 Add combo multiplier
s    a7 tweak
```

Rewrite the combined messages:
1. `Initialize score system scaffolding`
2. `Add score tracking with bug fixes`
3. `Add combo multiplier to score calculation`

## Rebase onto main

```bash
git rebase main
```

## Fast-forward merge

```bash
git checkout main
git merge feature/cleanup-practice
```

## After

```bash
git log --oneline
# 3 clean commits on top of main
```

---

## Interactive rebase editor commands

| Command | What it does |
|---|---|
| `pick` (or `p`) | Keep the commit as-is |
| `squash` (or `s`) | Fold into the commit above, combine messages |
| `fixup` (or `f`) | Fold into the commit above, discard this message |
| `reword` (or `r`) | Keep the commit, but edit the message |
| `drop` (or `d`) | Delete the commit entirely |
| `edit` (or `e`) | Pause here so you can amend the commit |

## The one rule everyone hits

**The first line must always be `pick`.** You can't squash into nothing — `squash` folds a commit into the one *above* it. If you put `s` on the first line, the rebase fails because there's no commit above it to fold into.

If you want to reword the first commit, use `r` (reword), not `s`.
