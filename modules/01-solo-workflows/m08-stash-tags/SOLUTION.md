# Solution — m08

> **Try the challenge yourself first.**

---

## Answer

```bash
# Start mid-feature
# edit index.js: add some in-progress work
git stash

# Make the urgent fix
git add .
git commit -m "Hotfix: patch critical bug"

# Tag it as a release
git tag -a v1.2-hotfix -m "Hotfix release — patch critical bug"

# Restore your in-progress work
git stash pop

# Verify
git tag
git stash list
```

`git stash list` should be empty after the pop. `git tag` should show your hotfix tag.

---

## .gitignore

```
# macOS
.DS_Store

# Dependencies
node_modules/

# Logs
*.log
```

Commit it:
```bash
git add .gitignore
git commit -m "Add gitignore for DS_Store, node_modules, logs"
```

---

## The gotcha with .gitignore

`.gitignore` only affects **untracked** files. If a file was already committed before you added it to `.gitignore`, Git keeps tracking it — the ignore rule does nothing.

To stop tracking a file that's already in the repo:
```bash
git rm --cached <file>
git commit -m "Stop tracking <file>"
```

`git rm --cached` removes the file from Git's index (stops tracking it) without deleting it from your disk. After that, the `.gitignore` rule kicks in and Git ignores future changes to it.

This comes up a lot with `node_modules/` or `.env` files that got committed by accident early in a project.
