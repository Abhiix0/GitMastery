# Lab — Seeing exactly what changed

**Working directory:** `sandbox/stack-overflown/`

---

## Steps

**1. Make a change to `index.html`** — find the game subtitle text and change it to something different.

**2. See the unstaged change:**
```bash
git diff
```
Lines starting with `-` are what was there before. Lines starting with `+` are what's there now. Everything else is context.

**3. Stage the file:**
```bash
git add index.html
```

**4. Run `git diff` again:**
```bash
git diff
```
Nothing. Once a file is staged, `git diff` (with no flags) stops showing it — your working directory now matches the staging area.

**5. See the staged change:**
```bash
git diff --staged
```
Now you see it. This compares what's staged against the last commit.

**6. Commit:**
```bash
git commit -m "Update subtitle text"
```

**7. Compare to the previous commit:**
```bash
git diff HEAD~1
```
`HEAD~1` means "one commit before HEAD". This shows everything that changed between that commit and your current working directory.

**8. Now make changes to TWO files** — edit `index.html` again and also edit `style.css`. Stage only `index.html`:
```bash
git add index.html
```
Leave `style.css` unstaged.

**9. Check what's unstaged:**
```bash
git diff
```
Only `style.css` shows up — it's the only file that differs between your working directory and the staging area.

**10. Check what's staged:**
```bash
git diff --staged
```
Only `index.html` — that's what differs between staging and the last commit.

**11. See everything at once:**
```bash
git diff HEAD
```
Both files. This compares your working directory AND staging area against the last commit.

---

## Verification

| Command | Compares |
|---|---|
| `git diff` | working directory → staging area |
| `git diff --staged` | staging area → last commit |
| `git diff HEAD` | working directory + staging → last commit |
