#!/bin/bash

# m14-debugging/lab/bisect-setup.sh
# Creates a 10-commit repo where commit 7 introduces a bug in calculateScore.
# Run from modules/03-power-tools/m14-debugging/lab/

set -e

if [ -d "bisect-workspace" ]; then
  echo "🧹 Removing previous bisect-workspace..."
  rm -rf bisect-workspace
fi

mkdir bisect-workspace
cd bisect-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Write the test script ─────────────────────────────────────────────────────
cat > test.sh << 'TESTSH'
#!/bin/bash
# Checks that calculateScore returns base * 10 for a given input.
# Exit 0 = PASS, exit 1 = FAIL

RESULT=$(node -e "
  const fs = require('fs');
  eval(fs.readFileSync('score.js', 'utf8'));
  const result = calculateScore(5);
  process.stdout.write(String(result));
" 2>/dev/null)

EXPECTED=50

if [ "$RESULT" = "$EXPECTED" ]; then
  echo "PASS — calculateScore(5) returned $RESULT"
  exit 0
else
  echo "FAIL — calculateScore(5) returned '$RESULT', expected $EXPECTED"
  exit 1
fi
TESTSH
chmod +x test.sh

# ── Commit 1: Initial score.js (correct) ─────────────────────────────────────
cat > score.js << 'JS'
// Score calculation
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}
JS
git add .
git commit -m "Add calculateScore function"

# ── Commit 2: Add comment ─────────────────────────────────────────────────────
cat > score.js << 'JS'
// Score calculation
// Each pattern cleared is worth 10 points
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}
JS
git add score.js
git commit -m "Add comment to calculateScore"

# ── Commit 3: Add level bonus ─────────────────────────────────────────────────
cat > score.js << 'JS'
// Score calculation
// Each pattern cleared is worth 10 points
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}

function levelBonus(level) {
  return level * 50;
}
JS
git add score.js
git commit -m "Add levelBonus function"

# ── Commit 4: Add high score tracker ─────────────────────────────────────────
cat > score.js << 'JS'
// Score calculation
// Each pattern cleared is worth 10 points
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}

function levelBonus(level) {
  return level * 50;
}

let highScore = 0;
function updateHighScore(current) {
  if (current > highScore) highScore = current;
  return highScore;
}
JS
git add score.js
git commit -m "Add high score tracking"

# ── Commit 5: Refactor comment ────────────────────────────────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}

function levelBonus(level) {
  return level * 50;
}

let highScore = 0;
function updateHighScore(current) {
  if (current > highScore) highScore = current;
  return highScore;
}
JS
git add score.js
git commit -m "Refactor scoring comments"

# ── Commit 6: Add combo multiplier (still correct) ───────────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 10;
}

function levelBonus(level) {
  return level * 50;
}

function comboBonus(combo) {
  return combo > 1 ? combo * 25 : 0;
}

let highScore = 0;
function updateHighScore(current) {
  if (current > highScore) highScore = current;
  return highScore;
}
JS
git add score.js
git commit -m "Add combo bonus function"

# ── Commit 7: THE BUG — multiplier changed from 10 to 1 ──────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 1;
}

function levelBonus(level) {
  return level * 50;
}

function comboBonus(combo) {
  return combo > 1 ? combo * 25 : 0;
}

let highScore = 0;
function updateHighScore(current) {
  if (current > highScore) highScore = current;
  return highScore;
}
JS
git add score.js
git commit -m "Refactor score calculation for readability"

# ── Commit 8: Add streak tracking (bug still present) ────────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 1;
}

function levelBonus(level) {
  return level * 50;
}

function comboBonus(combo) {
  return combo > 1 ? combo * 25 : 0;
}

let highScore = 0;
function updateHighScore(current) {
  if (current > highScore) highScore = current;
  return highScore;
}

let streak = 0;
function updateStreak(matched) {
  streak = matched ? streak + 1 : 0;
  return streak;
}
JS
git add score.js
git commit -m "Add streak tracking"

# ── Commit 9: Fix unrelated typo in comment ───────────────────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 1;
}

function levelBonus(level) {
  return level * 50;
}

function comboBonus(combo) {
  return combo > 1 ? combo * 25 : 0;
}

let highScore = 0;
function updateHighScore(score) {
  if (score > highScore) highScore = score;
  return highScore;
}

let streak = 0;
function updateStreak(matched) {
  streak = matched ? streak + 1 : 0;
  return streak;
}
JS
git add score.js
git commit -m "Rename parameter for clarity"

# ── Commit 10: Add reset function (bug still present) ─────────────────────────
cat > score.js << 'JS'
// Scoring system for Stack Overflown
// Base: 10 pts per pattern cleared
// Bonus: 50 pts per level reached
function calculateScore(patternsCleared) {
  return patternsCleared * 1;
}

function levelBonus(level) {
  return level * 50;
}

function comboBonus(combo) {
  return combo > 1 ? combo * 25 : 0;
}

let highScore = 0;
function updateHighScore(score) {
  if (score > highScore) highScore = score;
  return highScore;
}

let streak = 0;
function updateStreak(matched) {
  streak = matched ? streak + 1 : 0;
  return streak;
}

function resetGame() {
  streak = 0;
}
JS
git add score.js
git commit -m "Add resetGame function"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ bisect-workspace created with 10 commits."
echo ""
echo "The calculateScore function is broken — it returns the wrong value."
echo "One commit in this history introduced the bug."
echo ""
echo "Start here:"
echo "  cd bisect-workspace"
echo "  bash test.sh          ← confirm it's broken"
echo "  git log --oneline     ← see the history"
echo ""
echo "Then use git bisect to find the bad commit."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
