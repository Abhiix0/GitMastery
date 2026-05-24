# Lab — First repo from scratch

**Working directory:** `sandbox/stack-overflown/`

---

## Steps

**1. Navigate to the sandbox project:**
```bash
cd sandbox/stack-overflown/
```

**2. Initialize a Git repo:**
```bash
git init
```
Git creates a hidden `.git/` folder here. That's the entire repo — delete it and the history is gone.

**3. Check the status:**
```bash
git status
```
You'll see "No commits yet" and a list of untracked files. Git knows the files exist but isn't tracking them yet.

**4. Stage `index.html`:**
```bash
git add index.html
```

**5. Check status again:**
```bash
git status
```
`index.html` moved from "Untracked files" to "Changes to be committed". Everything else is still untracked.

**6. Stage the rest:**
```bash
git add .
```

**7. Confirm everything is staged:**
```bash
git status
```
All files should now be under "Changes to be committed".

**8. Make the first commit:**
```bash
git commit -m "Initial commit: Stack Overflown game"
```

**9. Check the log:**
```bash
git log
```
One commit. Note the hash, author, date, and message.

**10. Make a small change — open `index.html` and change the `<title>` text to something slightly different.**

**11. Check status:**
```bash
git status
```
You'll see `index.html` listed as "modified". It's changed in your working directory but not staged yet.

**12. See exactly what changed:**
```bash
git diff
```
Lines starting with `-` are removed, `+` are added.

**13. Stage and commit the change:**
```bash
git add index.html
git commit -m "Update page title"
```

**14. Check the log in compact form:**
```bash
git log --oneline
```

---

## Verification

`git log --oneline` should show exactly 2 commits.
