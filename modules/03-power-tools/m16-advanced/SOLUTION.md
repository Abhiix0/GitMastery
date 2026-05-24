# Solution — m16

> **Try the challenge yourself first.**

---

## Part 1 — Cherry-pick

Find the bug fix commit on the release branch:
```bash
git log release/v1 --oneline
```

Identify the one that's a real fix (not "WIP" or "in progress"). Copy its hash.

```bash
git checkout main
git cherry-pick <hash>
```

If there's a conflict:
```bash
# resolve the conflict markers in the affected file
git add <file>
git cherry-pick --continue
```

---

## Part 2 — Object graph walk

```bash
# Start at the cherry-picked commit
git log --oneline -1
git cat-file -p <commit-hash>
```

Output includes a `tree` line. Copy that hash:
```bash
git cat-file -p <tree-hash>
```

Output lists blobs. Find the fixed file, copy its blob hash:
```bash
git cat-file -p <blob-hash>
```

You're now looking at the raw file bytes as Git stores them — no metadata, no history, just content.

---

## Part 3 — The explanation

A good commit message body for this:

```
Cherry-pick bug fix from release/v1 (<original-hash>)

Git read the diff from the source commit — the delta between its parent and
itself — and applied that patch to the current working tree. It then created
a new commit object pointing to the current HEAD as its parent. The content
of the fixed file is identical to the original, but the commit hash is
different because the hash is computed from the content plus the parent
reference, and the parent changed.
```

---

## Why the hash changes — the full picture

Every Git object's hash is a SHA-1 of its contents. A commit object contains:

```
tree <tree-hash>
parent <parent-hash>
author ...
committer ...

<message>
```

When you cherry-pick, the `parent` field changes — it now points to your current HEAD instead of the original commit's parent. Different input → different SHA-1 → different hash.

The tree hash (and therefore the blob hashes) stay the same if the file content is identical. You can verify this:

```bash
# Get tree hash from original commit on release/v1
git cat-file -p <original-hash> | grep tree

# Get tree hash from cherry-picked commit on main
git cat-file -p <cherry-picked-hash> | grep tree
```

If no conflicts occurred, these tree hashes will match. Same files, same content — Git reuses the existing tree and blob objects. Only the commit object is new.

That's the object model in action: Git stores content, not diffs. Identical content gets the same hash and is stored once.
