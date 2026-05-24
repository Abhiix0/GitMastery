# Lab — Time travel in your repo

**Working directory:** `sandbox/stack-overflown/`

**Prerequisite:** Complete the m02 lab first. You need a repo with at least 2 commits.

---

## Steps

**1. Full log view:**
```bash
git log
```
Each entry shows the full hash, author, date, and message.

**2. Compact view:**
```bash
git log --oneline
```
One line per commit. Much easier to scan.

**3. Visual graph (linear for now):**
```bash
git log --oneline --graph
```
Looks boring with a straight history — it gets useful once you have branches.

**4. Show all refs:**
```bash
git log --oneline --graph --all --decorate
```
`--all` includes remote branches and tags. `--decorate` labels commits with branch/tag names.

**5. Copy the hash of your initial commit** (the oldest one at the bottom of `git log --oneline`).

**6. Check out that commit:**
```bash
git checkout <hash>
```
Read the "detached HEAD" warning. It means you're not on a branch — you're pointing directly at a commit. Any new commits you make here won't be attached to any branch.

**7. Look at `index.html`.** The title change you made in m02 is gone — you're looking at the project as it was at that exact commit.

**8. Come back to main:**
```bash
git checkout main
```
Or use the shortcut:
```bash
git checkout -
```

**9. Confirm the title change is back.** Check `index.html` — it should have your updated title.

**10. Show only the last 3 commits:**
```bash
git log --oneline -3
```

---

## Verification

You can navigate to any commit and back without losing work. `git log --oneline` shows your full history.
