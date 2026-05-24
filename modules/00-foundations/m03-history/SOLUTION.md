# Solution — m03

> **Try the challenge yourself first.**

---

## Answer

Find the commit hash for "Update page title":
```bash
git log --oneline
```

Navigate to the commit just before it (the initial commit):
```bash
git checkout <initial-commit-hash>
```

Check `index.html` — the title is the original one. The "Update page title" change doesn't exist yet at this point in history.

Come back:
```bash
git checkout main
```

## Seeing what changed without checking out

```bash
git show <hash>
```

`git show` prints the commit metadata (author, date, message) followed by the full diff for that commit. No checkout needed, no detached HEAD, nothing changes in your working directory.

Another way to see the same thing:
```bash
git diff <hash>^..<hash>
```

`<hash>^` means "the parent of this commit". So this compares the commit to the one right before it — same result as `git show`, just more explicit about what you're diffing.

`git show` is the one you'll reach for most often.
