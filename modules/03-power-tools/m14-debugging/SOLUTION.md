# Solution — m14

> **Try the challenge yourself first.**

---

## The test script

Create `test.sh` in the `bisect-workspace/` directory:

```bash
#!/bin/bash
node -e "const {calculateScore} = require('./index.js'); process.exit(calculateScore(10) === 1000 ? 0 : 1)"
```

Make it executable:
```bash
chmod +x test.sh
```

The script exits `0` (success) if the function returns the correct value, `1` (failure) if it doesn't. `git bisect run` interprets exit `0` as good and anything non-zero as bad.

## Running automated bisect

```bash
git bisect start
git bisect bad
git bisect good HEAD~9
git bisect run ./test.sh
```

Git runs the script at each midpoint automatically. When it's done, it prints the first bad commit and resets itself.

## Finding the exact line

```bash
git blame index.js | grep "NaN"
```

Note the hash. Then:
```bash
git show <hash>
```

## The fix commit

```bash
# Fix the line in index.js — replace `score * NaN` with the correct calculation
git add index.js
git commit -m "Fix calculateScore regression (introduced in <bad-commit-hash>)"
```

Replace `<bad-commit-hash>` with the actual short hash bisect identified.

---

## Why reference the bad commit in the message

When someone runs `git log` six months from now and sees this fix, they can immediately jump to the commit that caused it:

```bash
git show <bad-commit-hash>
```

That tells them what the original intent was, who wrote it, and what else changed at the same time. It's the difference between a commit message that's useful and one that just says "fix bug".

This pattern — `Fix X (introduced in <hash>)` or `Fix X (see #issue)` — is standard in projects with serious commit hygiene.
