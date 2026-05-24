#!/bin/bash

# br01-detached-head/setup.sh
# Creates a repo stuck in detached HEAD state.
# Run from broken-repos/br01-detached-head/

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "br01-workspace" ]; then
  echo "🧹 Removing previous br01-workspace..."
  rm -rf br01-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir br01-workspace
cd br01-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Commit 1: Initial ─────────────────────────────────────────────────────────
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <p>Game goes here.</p>
  </body>
</html>
HTML

git add .
git commit -m "Initial commit"

# ── Commit 2: Add header ──────────────────────────────────────────────────────
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <header>
      <h1>🧱 Stack Overflown</h1>
    </header>
    <p>Game goes here.</p>
  </body>
</html>
HTML

git add index.html
git commit -m "Add header"

# ── Commit 3: Add footer ──────────────────────────────────────────────────────
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <header>
      <h1>🧱 Stack Overflown</h1>
    </header>
    <p>Game goes here.</p>
    <footer>
      <p>© 2025 Stack Overflown</p>
    </footer>
  </body>
</html>
HTML

git add index.html
git commit -m "Add footer"

# ── Detach HEAD ───────────────────────────────────────────────────────────────
# Disable set -e — git checkout in detached state exits 0 but prints a warning
# that could confuse the output. We want the warning to show.
set +e
git checkout HEAD~2
set -e

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "😱 You're in detached HEAD state."
echo ""
echo "Run: git status — read what it says carefully."
echo ""
echo "Make a new file called hotfix.html and commit it."
echo "Then figure out how to keep that commit before it disappears."
echo ""
echo "Hint: you need to attach your commits to something permanent."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Your workspace: broken-repos/br01-detached-head/br01-workspace/"
echo ""
