#!/bin/bash

# s01-rescue-the-release/setup.sh
# Creates a broken release scenario with a NaN bug on release/v2
# and an unmerged hotfix on hotfix/score-crash.
# Run from scenarios/s01-rescue-the-release/

set -e

# ── Cleanup any previous run ──────────────────────────────────────────────────
if [ -d "s01-workspace" ]; then
  echo "🧹 Removing previous s01-workspace..."
  rm -rf s01-workspace
fi

# ── Create workspace ──────────────────────────────────────────────────────────
mkdir s01-workspace
cd s01-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Create src/ with game files ───────────────────────────────────────────────
mkdir src

# src/index.html
cat > src/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Stack Overflown v2.0</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <div class="game-container">
      <h1>🧱 Stack Overflown</h1>
      <div class="score-panel">
        <h3>Score</h3>
        <div id="score">0</div>
      </div>
      <canvas id="gameCanvas" width="300" height="600"></canvas>
    </div>
    <script src="patterns.js"></script>
    <script src="index.js"></script>
  </body>
</html>
HTML

# src/style.css
cat > src/style.css << 'CSS'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Courier New", monospace;
  background: #1e1e1e;
  color: #d4d4d4;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

.game-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

h1 {
  color: #f48771;
  font-size: 2em;
}

.score-panel {
  background: #252526;
  border: 2px solid #3e3e42;
  padding: 15px 30px;
  border-radius: 8px;
  text-align: center;
}

#score {
  font-size: 2.5em;
  color: #ce9178;
  font-weight: bold;
}

canvas {
  border: 3px solid #f48771;
  background: #252526;
}
CSS

# src/patterns.js
cat > src/patterns.js << 'JS'
const patterns = [];
JS

# src/index.js — correct version
cat > src/index.js << 'JS'
let score = 0;
const canvas = document.getElementById("gameCanvas");

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score;
}

function init() {
  console.log("Stack Overflown v2.0 initialised");
  updateScore(0);
}

window.addEventListener("load", init);
JS

# ── Commit 1: Initial game setup ──────────────────────────────────────────────
git add .
git commit -m "Initial game setup"

INITIAL_COMMIT=$(git rev-parse HEAD)

# ── Commit 2: Add game loop ───────────────────────────────────────────────────
git commit --allow-empty -m "Add game loop"

# ── Commit 3: Add pattern matching ───────────────────────────────────────────
git commit --allow-empty -m "Add pattern matching"

# ── Branch: release/v2 ───────────────────────────────────────────────────────
git checkout -b release/v2

# ── Introduce the NaN bug on release/v2 ──────────────────────────────────────
cat > src/index.js << 'JS'
let score = 0;
const canvas = document.getElementById("gameCanvas");

function updateScore(points) {
  score += points;
  document.getElementById("score").textContent = score * undefined;
}

function init() {
  console.log("Stack Overflown v2.0 initialised");
  updateScore(0);
}

window.addEventListener("load", init);
JS

git add src/index.js
git commit -m "Refactor score calculation"

# ── Branch: hotfix/score-crash from main (not release/v2) ────────────────────
git checkout main
git checkout -b hotfix/score-crash

# ── Add the crash fix on hotfix/score-crash ───────────────────────────────────
cat > src/index.js << 'JS'
let score = 0;
const canvas = document.getElementById("gameCanvas");

function updateScore(points) {
  if (typeof score === "undefined") score = 0;
  score += points;
  document.getElementById("score").textContent = score;
}

function init() {
  console.log("Stack Overflown v2.0 initialised");
  updateScore(0);
}

window.addEventListener("load", init);
JS

git add src/index.js
git commit -m "Fix crash when score is undefined"

# ── Return to main ────────────────────────────────────────────────────────────
git checkout main

# ── Print learner instructions ────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚨 S01: Rescue the Release"
echo ""
echo "Run: git log --all --graph --oneline to see the current state."
echo ""
echo "release/v2 has a bug. hotfix/score-crash has a fix for something else."
echo "Two hours until ship time. Go."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Workspace: scenarios/s01-rescue-the-release/s01-workspace/"
echo ""
echo "Start here:"
echo "  cd s01-workspace"
echo "  git log --all --graph --oneline"
echo ""
