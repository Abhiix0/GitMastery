# Solution — m04

> **Try the challenge yourself first.**

---

## Comparing two commits without checking out

Get your commit hashes:
```bash
git log --oneline
```

Diff between them:
```bash
git diff <old-hash>..<new-hash>
```

This shows every line added or removed between those two commits. Order matters — old on the left, new on the right. Flip them and the `+`/`-` signs flip too.

You can also use relative refs:
```bash
git diff HEAD~1..HEAD
```
Same thing — compares the previous commit to the current one.

---

## Tracking 3 files in different states

Say you edited `index.html`, `style.css`, and `script.js`, then staged only `index.html` and `style.css`:

```bash
git add index.html style.css
# leave script.js unstaged
```

**What's unstaged (working dir vs staging):**
```bash
git diff
```
Shows only `script.js`.

**What's staged (staging vs last commit):**
```bash
git diff --staged
```
Shows `index.html` and `style.css`.

**Full picture (everything vs last commit):**
```bash
git diff HEAD
```
Shows all three files.

**Quick overview of all states:**
```bash
git status
```
`index.html` and `style.css` under "Changes to be committed". `script.js` under "Changes not staged for commit".

Between `git status` and the three diff commands, you have complete visibility into exactly where every change lives.
