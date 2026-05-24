#!/bin/bash

# br03-lost-commits/setup.sh
# Creates a repo where 3 commits have been "lost" via git reset --hard.
# Run from broken-repos/br03-lost-commits/

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "br03-workspace" ]; then
  echo "🧹 Removing previous br03-workspace..."
  rm -rf br03-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir br03-workspace
cd br03-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Commit 1: Setup ───────────────────────────────────────────────────────────
cat > game.js << 'JS'
let score = 0;
let display = document.getElementById("score");

function updateScore(points) {
  score += points;
  display.textContent = score;
}
JS

git add .
git commit -m "Setup"

# ── Commit 2: High score tracking ─────────────────────────────────────────────
cat > game.js << 'JS'
let score = 0;
let highScore = 0;
let display = document.getElementById("score");
let highScoreDisplay = document.getElementById("high-score");

function updateScore(points) {
  score += points;
  display.textContent = score;
}

function updateHighScore() {
  if (score > highScore) {
    highScore = score;
    highScoreDisplay.textContent = highScore;
    localStorage.setItem("highScore", highScore);
  }
}
JS

git add game.js
git commit -m "Add high score tracking"

# ── Commit 3: Level progression ───────────────────────────────────────────────
cat > game.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;
let display = document.getElementById("score");
let highScoreDisplay = document.getElementById("high-score");
let levelDisplay = document.getElementById("level");

function updateScore(points) {
  score += points;
  display.textContent = score;
}

function updateHighScore() {
  if (score > highScore) {
    highScore = score;
    highScoreDisplay.textContent = highScore;
    localStorage.setItem("highScore", highScore);
  }
}

function updateLevel() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) {
    level++;
    levelDisplay.textContent = level;
  }
}
JS

git add game.js
git commit -m "Add level progression"

# ── Commit 4: Combo multiplier ────────────────────────────────────────────────
cat > game.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;
let combo = 0;
let display = document.getElementById("score");
let highScoreDisplay = document.getElementById("high-score");
let levelDisplay = document.getElementById("level");

function updateScore(points) {
  const multiplier = 1 + (combo * 0.5);
  score += Math.floor(points * multiplier);
  display.textContent = score;
}

function updateHighScore() {
  if (score > highScore) {
    highScore = score;
    highScoreDisplay.textContent = highScore;
    localStorage.setItem("highScore", highScore);
  }
}

function updateLevel() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) {
    level++;
    levelDisplay.textContent = level;
  }
}

function updateCombo(matched) {
  combo = matched ? combo + 1 : 0;
}
JS

git add game.js
git commit -m "Add combo multiplier"

# ── Lose the last 3 commits ───────────────────────────────────────────────────
git reset --hard HEAD~3

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💀 You just ran git reset --hard and lost 3 commits."
echo ""
echo "Run: git log — they're gone from the log."
echo ""
echo "Your mission: get them back. All three."
echo ""
echo "Hint: Git didn't actually delete them. Check git reflog."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Your workspace: broken-repos/br03-lost-commits/br03-workspace/"
echo ""
