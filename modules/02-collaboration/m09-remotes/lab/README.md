# Lab — Connecting to a remote

**Working directory:** `sandbox/stack-overflown/`

> **Requires a GitHub account.** If you don't have one, create one at [github.com](https://github.com) — it's free.

---

## Steps

**1. Make sure your local repo has at least one commit:**
```bash
git log --oneline
```
If it's empty, go back and complete the m02 lab first.

**2. Create a new repo on GitHub:**
- Go to [github.com](https://github.com) → click **New repository**
- Name it `stack-overflown-practice`
- Leave "Add a README" unchecked — you already have files locally
- Click **Create repository**

**3. Connect your local repo to the remote:**
```bash
git remote add origin https://github.com/YOUR_USERNAME/stack-overflown-practice.git
```
Replace `YOUR_USERNAME` with your actual GitHub username.

**4. Confirm the remote is set:**
```bash
git remote -v
```
You should see `origin` listed twice — once for fetch, once for push.

**5. Push your local main branch:**
```bash
git push -u origin main
```
`-u` sets up tracking so future `git push` and `git pull` commands know where to go without you specifying.

**6. Go to GitHub and confirm your files are there.** Refresh the repo page — you should see `index.html`, `index.js`, `style.css`, etc.

**7. Make a change directly on GitHub:**
- Click `index.html` → click the pencil icon (Edit)
- Change the `<title>` text to something slightly different
- Scroll down → click **Commit changes**

**8. Back in your terminal, fetch the remote change:**
```bash
git fetch origin
```
This downloads the change but doesn't apply it yet. Your working directory is untouched.

**9. See that the remote is ahead:**
```bash
git log --all --oneline
```
You'll see `origin/main` is one commit ahead of your local `main`.

**10. Pull the change:**
```bash
git pull
```
This merges the remote commit into your local branch.

**11. Confirm you're in sync:**
```bash
git log --oneline
```
Local and remote are at the same commit.

---

## Verification

`git log --oneline` shows the commit you made on GitHub. Your local `index.html` has the title change you made in the browser.
