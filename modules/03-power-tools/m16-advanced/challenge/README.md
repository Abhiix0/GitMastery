# Challenge — m16

The `release/v1` branch has one critical bug fix commit buried among 5 other unfinished commits.

**Part 1:** Cherry-pick only the bug fix commit to main. If there's a conflict, resolve it.

**Part 2:** Use `git cat-file` to walk the object graph from the cherry-picked commit all the way down to the raw bytes of the fixed file. Go all the way: commit → tree → blob.

**Part 3:** Write a 3-sentence explanation of what happened at the Git object level when you cherry-picked. Put it as a comment in the body of the cherry-pick commit message (after the subject line).

The explanation should cover: what Git read, what it created, and why the hash changed.
