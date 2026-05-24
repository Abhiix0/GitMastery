#!/bin/bash

# br02-merge-conflict/setup.sh
# Creates a broken repo stuck mid-merge conflict.
# Run this from the broken-repos/br02-merge-conflict/ directory.

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "br02-workspace" ]; then
  echo "🧹 Removing previous br02-workspace..."
  rm -rf br02-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir br02-workspace
cd br02-workspace

# ── Init repo ─────────────────────────────────────────────────────────────────
git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Initial commit ────────────────────────────────────────────────────────────
cat > game.js << 'GAMEJS'
function updateScore(points) {
  score = score + points;
  display.textContent = score;
}
GAMEJS

git add .
git commit -m "Initial game setup"

# ── Branch: feature-multiplier ────────────────────────────────────────────────
git checkout -b feature-multiplier

cat > game.js << 'GAMEJS'
function updateScore(points) {
  score = score + (points * multiplier);
  display.textContent = score;
  console.log("Score updated:", score);
}
GAMEJS

git add game.js
git commit -m "Add score multiplier"

# ── Back to main ──────────────────────────────────────────────────────────────
git checkout main 2>/dev/null || git checkout master 2>/dev/null

# ── Change on main ────────────────────────────────────────────────────────────
cat > game.js << 'GAMEJS'
function updateScore(points) {
  score = score + points;
  highScore = Math.max(score, highScore);
  display.textContent = score;
}
GAMEJS

git add game.js
git commit -m "Track high score"

# ── Trigger the conflict (do NOT resolve) ─────────────────────────────────────
# Disable set -e temporarily — merge will exit non-zero on conflict
set +e
git merge feature-multiplier --no-edit
MERGE_EXIT=$?
set -e

if [ $MERGE_EXIT -eq 0 ]; then
  echo ""
  echo "⚠️  Merge succeeded without a conflict — something went wrong with the setup."
  echo "    The conflict should have been triggered. Check the script."
  exit 1
fi

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💥 Conflict in progress. Run: git status"
echo ""
echo "Your job: resolve the conflict so BOTH features work."
echo "The final updateScore should handle multiplier AND high score tracking."
echo ""
echo "Run: node -e 'require(\"./game.js\")' to verify (or just read the code)."
echo ""
echo "When done: git add game.js && git commit"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Your workspace: broken-repos/br02-merge-conflict/br02-workspace/"
echo ""
