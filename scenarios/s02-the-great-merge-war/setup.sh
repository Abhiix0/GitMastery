#!/bin/bash

# s02-the-great-merge-war/setup.sh
# Creates three feature branches that all modify index.js in conflicting ways.
# Run from scenarios/s02-the-great-merge-war/

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "s02-workspace" ]; then
  echo "🧹 Removing previous s02-workspace..."
  rm -rf s02-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir s02-workspace
cd s02-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

mkdir src

# ── Base index.html ───────────────────────────────────────────────────────────
cat > src/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <h1>🧱 Stack Overflown</h1>
    <div class="panel">
      <h3>Score</h3>
      <div id="score">0</div>
    </div>
    <script src="index.js"></script>
  </body>
</html>
HTML

# ── Base index.js ─────────────────────────────────────────────────────────────
cat > src/index.js << 'JS'
let score = 0;
let patternsCleared = 0;

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;
}

function checkPatternMatch() {
  patternsCleared++;
  updateScore(100);
}

function startGame() {
  score = 0;
  patternsCleared = 0;
  document.getElementById("score").textContent = 0;
}
JS

# ── Commit 1: Base game setup ─────────────────────────────────────────────────
git add .
git commit -m "Base game setup"

BASE_COMMIT=$(git rev-parse HEAD)

# ═══════════════════════════════════════════════════════════════════════════════
# BRANCH 1: feature/high-score
# Developer A adds high score tracking
# ═══════════════════════════════════════════════════════════════════════════════

git checkout -b feature/high-score

cat > src/index.js << 'JS'
let score = 0;
let highScore = 0;
let patternsCleared = 0;

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;

  if (score > highScore) {
    highScore = score;
    document.getElementById("high-score").textContent = highScore;
  }
}

function checkPatternMatch() {
  patternsCleared++;
  updateScore(100);
}

function startGame() {
  score = 0;
  patternsCleared = 0;
  document.getElementById("score").textContent = 0;
  document.getElementById("high-score").textContent = highScore;
}
JS

cat > src/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <h1>🧱 Stack Overflown</h1>
    <div class="panel">
      <h3>Score</h3>
      <div id="score">0</div>
      <h3>High Score</h3>
      <div id="high-score">0</div>
    </div>
    <script src="index.js"></script>
  </body>
</html>
HTML

git add .
git commit -m "Add high score tracking"

# ═══════════════════════════════════════════════════════════════════════════════
# BRANCH 2: feature/level-counter
# Developer B adds level progression
# ═══════════════════════════════════════════════════════════════════════════════

git checkout main

git checkout -b feature/level-counter

cat > src/index.js << 'JS'
let score = 0;
let patternsCleared = 0;
let level = 1;

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;
  console.log("Score:", score);
}

function checkPatternMatch() {
  patternsCleared++;
  updateScore(100);

  if (patternsCleared % 5 === 0) {
    level++;
    document.getElementById("level").textContent = level;
  }
}

function startGame() {
  score = 0;
  patternsCleared = 0;
  level = 1;
  document.getElementById("score").textContent = 0;
  document.getElementById("level").textContent = 1;
}
JS

cat > src/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <h1>🧱 Stack Overflown</h1>
    <div class="panel">
      <h3>Score</h3>
      <div id="score">0</div>
      <h3>Level</h3>
      <div id="level">1</div>
    </div>
    <script src="index.js"></script>
  </body>
</html>
HTML

git add .
git commit -m "Add level counter"

# ═══════════════════════════════════════════════════════════════════════════════
# BRANCH 3: feature/pause-button
# Developer C adds pause/resume
# ═══════════════════════════════════════════════════════════════════════════════

git checkout main

git checkout -b feature/pause-button

cat > src/index.js << 'JS'
let score = 0;
let patternsCleared = 0;
let isPaused = false;

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;
}

function checkPatternMatch() {
  if (isPaused) return;
  patternsCleared++;
  updateScore(100);
}

function togglePause() {
  isPaused = !isPaused;
  document.getElementById("pause-btn").textContent = isPaused ? "Resume" : "Pause";
}

function startGame() {
  score = 0;
  patternsCleared = 0;
  isPaused = false;
  document.getElementById("score").textContent = 0;
  document.getElementById("pause-btn").textContent = "Pause";
}
JS

cat > src/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Stack Overflown</title>
  </head>
  <body>
    <h1>🧱 Stack Overflown</h1>
    <div class="panel">
      <h3>Score</h3>
      <div id="score">0</div>
    </div>
    <button id="pause-btn" onclick="togglePause()">Pause</button>
    <script src="index.js"></script>
  </body>
</html>
HTML

git add .
git commit -m "Add pause button"

# ── Return to main ────────────────────────────────────────────────────────────
git checkout main

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚔️  S02: The Great Merge War"
echo ""
echo "Run: git log --all --graph --oneline to see what you're dealing with."
echo ""
echo "Three branches. Three features. All touching index.js."
echo "Get them all onto main. All three features must work."
echo ""
echo "Good luck."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Workspace: scenarios/s02-the-great-merge-war/s02-workspace/"
echo ""
echo "Start here:"
echo "  cd s02-workspace"
echo "  git log --all --graph --oneline"
echo ""
