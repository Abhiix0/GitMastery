# Solution — m07

> **Try the challenge yourself first.** Conflict resolution is a skill you build by doing it, not reading about it.

---

## Setup

```bash
git checkout main

# Branch 1: add input validation to updateScore
git checkout -b feature/score-validation
# edit updateScore to guard against invalid input, e.g.:
# function updateScore(points) {
#   if (typeof points !== 'number') return;
#   score += points;
# }
git add index.js
git commit -m "Add input validation to updateScore"
git checkout main

# Branch 2: change score calculation
git checkout -b feature/score-multiplier
# edit updateScore to apply a multiplier, e.g.:
# function updateScore(points) {
#   score += points * multiplier;
# }
git add index.js
git commit -m "Apply score multiplier in updateScore"
git checkout main

# Merge first branch (clean)
git merge feature/score-validation

# Merge second branch (conflict)
git merge feature/score-multiplier
```

## Resolving

Open `index.js`. The conflict will be inside `updateScore`. Read both sides before touching anything.

The goal is a function that has **both** the validation guard **and** the multiplier:

```js
function updateScore(points) {
  if (typeof points !== 'number') return;
  score += points * multiplier;
}
```

Delete the conflict markers, save, then:

```bash
git add index.js
git commit
```

## The most common mistake

Picking one side and deleting the other without reading what it does.

When you're under pressure or the conflict looks messy, it's tempting to just keep "your" version and throw away the incoming changes. That silently drops real work. Always read both sides and understand what each one is doing before you decide what the resolved version should look like.

If you're not sure what a side does — check `git log` and `git show` on the incoming branch before merging.
