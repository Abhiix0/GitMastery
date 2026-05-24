# Solution — m02

> **Try the challenge yourself first.** The whole point is writing the commit messages — don't skip it.

---

## Answer

```bash
mkdir temp-story && cd temp-story
git init

# Commit 1
echo "# My App" > README.md
git add README.md
git commit -m "Add README with project description"

# Commit 2
echo "body { margin: 0; }" > style.css
git add style.css
git commit -m "Add base stylesheet with reset"

# Commit 3
echo "<html><head><title>My App</title></head></html>" > index.html
git add index.html
git commit -m "Add HTML entry point linking to stylesheet"
```

Verify:
```bash
git log --oneline
```

Expected output (hashes will differ):
```
a3f9c12 Add HTML entry point linking to stylesheet
b1e4d08 Add base stylesheet with reset
9c2a771 Add README with project description
```

## The story part matters

Reading those three messages in order, you understand: someone started a project, gave it a stylesheet, then wired up the HTML. That's a story.

"Add file1 / Add file2 / Add file3" tells you nothing. Commit messages are documentation — future you (and teammates) will read them when something breaks at 2am.
