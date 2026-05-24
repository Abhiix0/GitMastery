# Solution — m09

> **Try the challenge yourself first.**

---

## Part 1 — clean pull

```bash
# Edit a file on GitHub (e.g. change a comment in index.html)
# Then locally:
git pull
git log --oneline
```

No conflict because you didn't touch that file locally. Git fast-forwards.

---

## Part 2 — conflict pull

Set it up:
- On GitHub: edit `index.html`, change the `<title>` to "Stack Overflown v2"
- Locally (without pulling first): edit `index.html`, change the `<title>` to "Stack Overflown — Local"
- Commit locally:

```bash
git add index.html
git commit -m "Update title locally"
```

Now pull:
```bash
git pull
```

Git will hit a conflict. Open `index.html`, find the markers, and resolve:

```html
<title>Stack Overflown — Local and v2</title>
```

(Or whatever makes sense — the point is you pick the final version.)

```bash
git add index.html
git commit
git push
```

---

## How `git pull` actually works

`git pull` is just two commands back to back:

```bash
git fetch origin   # download remote changes
git merge origin/main  # merge them into your current branch
```

If you want to see what's coming before committing to the merge:

```bash
git fetch origin
git diff main origin/main
```

This shows you exactly what the remote has that you don't, before anything touches your working directory. Useful when you're not sure what a teammate changed.
