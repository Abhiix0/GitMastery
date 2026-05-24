# Solution — m05

> **Try the challenge yourself first.**

---

## Answer

```bash
# Start from main
git checkout main

# Branch 1 — touches index.js
git checkout -b feature/js-comment
# edit index.js: add a comment
git add index.js
git commit -m "Add comment to index.js"
git checkout main

# Branch 2 — touches index.html
git checkout -b feature/html-title
# edit index.html: change the title
git add index.html
git commit -m "Update title in index.html"
git checkout main

# Merge both
git merge feature/js-comment
git merge feature/html-title

# View the graph
git log --oneline --graph

# Clean up
git branch -d feature/js-comment
git branch -d feature/html-title
```

## Key insight

Branches that touch different files (or different lines in the same file) merge cleanly. Git can combine them automatically because there's no ambiguity about what the final result should look like.

Conflicts only happen when two branches modify the **same lines** in the same file. Git doesn't know which version you want, so it stops and asks you to decide.

That's the whole mental model for avoiding unnecessary conflicts: keep branches focused on one thing, and they'll merge without drama.
