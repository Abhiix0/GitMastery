#!/bin/bash

# br02-merge-conflict/verify.sh
# Checks whether the learner resolved the conflict correctly.
# Run from broken-repos/br02-merge-conflict/ (not from inside br02-workspace/).

WORKSPACE="br02-workspace"
GAME_FILE="$WORKSPACE/game.js"
PASS=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  br02-merge-conflict — verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Check workspace exists ────────────────────────────────────────────────────
if [ ! -d "$WORKSPACE" ]; then
  echo "❌ br02-workspace/ not found."
  echo "   Run: bash setup.sh first."
  echo ""
  exit 1
fi

if [ ! -f "$GAME_FILE" ]; then
  echo "❌ game.js not found in br02-workspace/."
  echo "   Something went wrong with setup. Re-run: bash setup.sh"
  echo ""
  exit 1
fi

# ── Check 1: No conflict markers in game.js ───────────────────────────────────
if grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$GAME_FILE"; then
  echo "❌ Conflict markers still present in game.js."
  echo "   Open the file and remove all <<<<<<<, =======, and >>>>>>> lines."
  PASS=false
else
  echo "✅ No conflict markers in game.js."
fi

# ── Check 2: Merge is complete (no MERGE_HEAD) ────────────────────────────────
if [ -f "$WORKSPACE/.git/MERGE_HEAD" ]; then
  echo "❌ Merge is still in progress (.git/MERGE_HEAD exists)."
  echo "   You need to commit the resolution: git add game.js && git commit"
  PASS=false
else
  echo "✅ Merge is complete (no pending MERGE_HEAD)."
fi

# ── Check 3: At least one commit beyond the initial three ─────────────────────
COMMIT_COUNT=$(git -C "$WORKSPACE" rev-list --count HEAD 2>/dev/null)
if [ "$COMMIT_COUNT" -lt 4 ]; then
  echo "❌ Expected at least 4 commits (initial + 2 branch commits + merge resolution)."
  echo "   Current count: $COMMIT_COUNT"
  echo "   Did you forget to commit after resolving?"
  PASS=false
else
  echo "✅ Commit count looks right ($COMMIT_COUNT commits)."
fi

# ── Check 4: Last commit message isn't a default auto-merge message ───────────
LAST_MSG=$(git -C "$WORKSPACE" log -1 --pretty=%s 2>/dev/null)
DEFAULT_MERGE_PATTERN="^Merge branch '"

if echo "$LAST_MSG" | grep -qE "$DEFAULT_MERGE_PATTERN"; then
  echo "❌ Last commit message looks like a default merge message:"
  echo "   \"$LAST_MSG\""
  echo "   Write a message that describes what you resolved and why."
  PASS=false
else
  echo "✅ Commit message is custom: \"$LAST_MSG\""
fi

# ── Check 5: game.js contains both features ───────────────────────────────────
HAS_MULTIPLIER=false
HAS_HIGH_SCORE=false

if grep -q "multiplier" "$GAME_FILE"; then
  HAS_MULTIPLIER=true
fi

if grep -q "highScore" "$GAME_FILE"; then
  HAS_HIGH_SCORE=true
fi

if [ "$HAS_MULTIPLIER" = false ]; then
  echo "❌ game.js doesn't reference 'multiplier' — the multiplier feature is missing."
  PASS=false
else
  echo "✅ Multiplier feature is present in game.js."
fi

if [ "$HAS_HIGH_SCORE" = false ]; then
  echo "❌ game.js doesn't reference 'highScore' — the high score feature is missing."
  PASS=false
else
  echo "✅ High score feature is present in game.js."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$PASS" = true ]; then
  echo ""
  echo "  ✅ All checks passed. Conflict resolved correctly."
  echo ""
  echo "  Both features are present, the merge is committed, and the"
  echo "  commit message is yours. That's what a clean resolution looks like."
  echo ""
else
  echo ""
  echo "  ❌ Some checks failed. See above for details."
  echo ""
  echo "  If you want to start over: bash setup.sh"
  echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
