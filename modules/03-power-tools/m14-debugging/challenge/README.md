# Challenge — m14

The `calculateScore` function in `bisect-workspace/index.js` was working at some point.

**Part 1:** Use `git bisect run` with a test script you write yourself to find the breaking commit automatically — no manual good/bad entries. Git runs your script at each step and decides good/bad based on the exit code.

**Part 2:** Use `git blame` to identify the exact line that's wrong.

**Part 3:** Fix it. Write the fix commit message in this format:
```
Fix calculateScore regression (introduced in <bad-commit-hash>)
```

The commit hash in the message should be the one `bisect` identified.
