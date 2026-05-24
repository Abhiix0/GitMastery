#!/bin/bash

# s04-the-rogue-commit/setup.sh
# Creates a 40-commit repo where commit ~28 introduces a high score regression.
# Run from scenarios/s04-the-rogue-commit/

set -e

if [ -d "s04-workspace" ]; then
  echo "🧹 Removing previous s04-workspace..."
  rm -rf s04-workspace
fi

mkdir s04-workspace
cd s04-workspace

git init
git config user.email "learner@gitmastery.local"
git config user.name "GitMastery Learner"

# ── Write test.sh ─────────────────────────────────────────────────────────────
cat > test.sh << 'TESTSH'
#!/bin/bash
# Tests that updateHighScore correctly tracks the highest value seen.
# Exit 0 = PASS, exit 1 = FAIL
#
# Usage with git bisect:
#   git bisect start
#   git bisect bad HEAD
#   git bisect good <known-good-hash>
#   git bisect run bash test.sh
#   git bisect reset

RESULT=$(node -e "
  const fs = require('fs');
  eval(fs.readFileSync('score.js', 'utf8'));

  // Reset state
  highScore = 0;

  // Test: high score should update when new score is higher
  updateHighScore(100);
  updateHighScore(200);
  updateHighScore(150);
  const final = updateHighScore(50);

  process.stdout.write(String(final));
" 2>/dev/null)

EXPECTED=200

if [ "$RESULT" = "$EXPECTED" ]; then
  echo "PASS — highScore correctly tracked to $RESULT"
  exit 0
else
  echo "FAIL — highScore returned '$RESULT', expected $EXPECTED"
  exit 1
fi
TESTSH
chmod +x test.sh

# ── Helper: commit a version of score.js ─────────────────────────────────────
commit_score() {
  local msg="$1"
  git add score.js
  git commit -m "$msg"
}

# ═══════════════════════════════════════════════════════════════════════════════
# COMMITS 1–10: Foundation (all correct)
# ═══════════════════════════════════════════════════════════════════════════════

cat > score.js << 'JS'
let score = 0;
let highScore = 0;

function updateScore(points) {
  score += points;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}
JS
git add .
commit_score "Initial scoring system"

KNOWN_GOOD=$(git rev-parse HEAD)

cat > score.js << 'JS'
let score = 0;
let highScore = 0;

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}
JS
commit_score "Return score from updateScore"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;

// Reset all score state
function resetScores() {
  score = 0;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}
JS
commit_score "Add resetScores function"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;

function resetScores() {
  score = 0;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}
JS
commit_score "Add level tracking"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;

function resetScores() {
  score = 0;
  patternsCleared = 0;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function incrementPatterns() {
  patternsCleared++;
  return patternsCleared;
}
JS
commit_score "Track patterns cleared"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;

function resetScores() {
  score = 0;
  patternsCleared = 0;
  level = 1;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function incrementPatterns() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) level++;
  return patternsCleared;
}
JS
commit_score "Level up every 5 patterns"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;

// Reset all game state for a new session
function resetScores() {
  score = 0;
  patternsCleared = 0;
  level = 1;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function incrementPatterns() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) level++;
  return patternsCleared;
}
JS
commit_score "Add comment to resetScores"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;
let combo = 0;

function resetScores() {
  score = 0;
  patternsCleared = 0;
  level = 1;
  combo = 0;
}

function updateScore(points) {
  score += points;
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function incrementPatterns() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) level++;
  return patternsCleared;
}

function updateCombo(matched) {
  combo = matched ? combo + 1 : 0;
  return combo;
}
JS
commit_score "Add combo tracking"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;
let combo = 0;

function resetScores() {
  score = 0;
  patternsCleared = 0;
  level = 1;
  combo = 0;
}

function updateScore(points) {
  const multiplier = combo > 0 ? 1 + (combo * 0.1) : 1;
  score += Math.floor(points * multiplier);
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function incrementPatterns() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) level++;
  return patternsCleared;
}

function updateCombo(matched) {
  combo = matched ? combo + 1 : 0;
  return combo;
}
JS
commit_score "Apply combo multiplier to score"

cat > score.js << 'JS'
let score = 0;
let highScore = 0;
let level = 1;
let patternsCleared = 0;
let combo = 0;

function resetScores() {
  score = 0;
  patternsCleared = 0;
  level = 1;
  combo = 0;
}

function updateScore(points) {
  const multiplier = combo > 0 ? 1 + (combo * 0.1) : 1;
  score += Math.floor(points * multiplier);
  return score;
}

function updateHighScore(current) {
  if (current > highScore) {
    highScore = current;
  }
  return highScore;
}

function getLevel() {
  return level;
}

function getLevelBonus() {
  return level * 50;
}

function incrementPatterns() {
  patternsCleared++;
  if (patternsCleared % 5 === 0) level++;
  return patternsCleared;
}

function updateCombo(matched) {
  combo = matched ? combo + 1 : 0;
  return combo;
}
JS
commit_score "Add getLevelBonus function"

# ═══════════════════════════════════════════════════════════════════════════════
# COMMITS 11–27: More features, refactors, comments (all correct)
# ═══════════════════════════════════════════════════════════════════════════════

for i in 11 12 13 14 15; do
  # Add/tweak comments only — no logic changes
  sed -i "s|// Reset all game state for a new session|// Reset all game state for a new session (call on game over)|" score.js 2>/dev/null || true
  git add score.js
  git commit -m "Refactor comment (pass $i)"
done

cat >> score.js << 'JS'

function getScoreSummary() {
  return { score, highScore, level, combo };
}
JS
commit_score "Add getScoreSummary helper"

cat >> score.js << 'JS'

function isNewHighScore() {
  return score > highScore;
}
JS
commit_score "Add isNewHighScore helper"

for i in 18 19 20; do
  echo "// v1.$i" >> score.js
  commit_score "Minor cleanup pass $i"
done

cat >> score.js << 'JS'

function getComboMultiplier() {
  return combo > 0 ? 1 + (combo * 0.1) : 1;
}
JS
commit_score "Extract getComboMultiplier"

for i in 22 23 24 25 26 27; do
  echo "// pass $i" >> score.js
  commit_score "Housekeeping pass $i"
done

# ═══════════════════════════════════════════════════════════════════════════════
# COMMIT 28: THE BUG — >= instead of > breaks high score tracking
# ═══════════════════════════════════════════════════════════════════════════════

# Read current score.js and replace the comparison operator
node -e "
  const fs = require('fs');
  let content = fs.readFileSync('score.js', 'utf8');
  // Change 'if (current > highScore)' to 'if (current >= highScore)' — subtle!
  // This means highScore always gets set to the LATEST score, not the HIGHEST
  content = content.replace(
    'if (current > highScore) {',
    'if (current >= highScore) {'
  );
  fs.writeFileSync('score.js', content);
"
commit_score "Refactor updateHighScore for consistency"

# ═══════════════════════════════════════════════════════════════════════════════
# COMMITS 29–40: More changes on top of the bug (bug persists)
# ═══════════════════════════════════════════════════════════════════════════════

for i in 29 30 31 32 33 34 35 36 37 38 39 40; do
  echo "// update $i" >> score.js
  commit_score "Update pass $i"
done

# ── Print instructions ────────────────────────────────────────────────────────
BAD_COMMIT=$(git log --oneline | grep "Refactor updateHighScore for consistency" | awk '{print $1}')

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ s04-workspace created with 40 commits."
echo ""
echo "The high score feature is broken. One commit introduced the regression."
echo ""
echo "Known-good commit (first commit): $KNOWN_GOOD"
echo ""
echo "Start here:"
echo "  cd s04-workspace"
echo "  bash test.sh                    ← confirm it's broken"
echo "  git log --oneline               ← see the history"
echo "  git bisect start"
echo "  git bisect bad HEAD"
echo "  git bisect good $KNOWN_GOOD"
echo "  git bisect run bash test.sh"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
