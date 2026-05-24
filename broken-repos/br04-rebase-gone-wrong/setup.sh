#!/bin/bash

# br04-rebase-gone-wrong/setup.sh
# Creates a repo stuck mid-rebase with an unresolved conflict.
# Run from broken-repos/br04-rebase-gone-wrong/

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "br04-workspace" ]; then
  echo "🧹 Removing previous br04-workspace..."
  rm -rf br04-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir br04-workspace
cd br04-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Commit 1: Base setup on main ──────────────────────────────────────────────
cat > app.js << 'JS'
const config = "default";

function startGame() {
  console.log("Starting game with config:", config);
}
JS

git add .
git commit -m "Base setup"

# ── Commit 2: Update main config (on main) ────────────────────────────────────
cat > app.js << 'JS'
const config = "main version";

function startGame() {
  console.log("Starting game with config:", config);
}
JS

git add app.js
git commit -m "Update main config"

# ── Create feature branch from the first commit ───────────────────────────────
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)
git checkout -b feature "$FIRST_COMMIT"

# ── Commit 3: Feature change A ────────────────────────────────────────────────
cat > app.js << 'JS'
const config = "feature version";

function startGame() {
  console.log("Starting game with config:", config);
}

function pauseGame() {
  console.log("Game paused.");
}
JS

git add app.js
git commit -m "Add pauseGame function"

# ── Commit 4: Feature change B ────────────────────────────────────────────────
cat > app.js << 'JS'
const config = "feature version";

function startGame() {
  console.log("Starting game with config:", config);
}

function pauseGame() {
  console.log("Game paused.");
}

function resumeGame() {
  console.log("Game resumed.");
}
JS

git add app.js
git commit -m "Add resumeGame function"

# ── Start the rebase (this will conflict on the first commit) ─────────────────
# Disable set -e — rebase exits non-zero on conflict
set +e
git rebase main 2>/dev/null
set -e

# ── Manually write conflict markers into app.js ───────────────────────────────
# The rebase stopped at the first feature commit because both main and feature
# changed the `config` line. We write the conflict markers directly to simulate
# the state after a developer walked away mid-conflict.
cat > app.js << 'JS'
<<<<<<< HEAD
const config = "main version";
=======
const config = "feature version";
>>>>>>> feature

function startGame() {
  console.log("Starting game with config:", config);
}

function pauseGame() {
  console.log("Game paused.");
}
JS

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔥 A rebase started, hit a conflict, and was abandoned."
echo ""
echo "Run: git status — the repo is confused."
echo ""
echo "You have two options: finish it or abort it."
echo "First: understand what's happening. Then: decide."
echo ""
echo "The goal: get the repo back to a clean state by any means."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Your workspace: broken-repos/br04-rebase-gone-wrong/br04-workspace/"
echo ""
