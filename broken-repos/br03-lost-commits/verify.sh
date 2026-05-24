#!/bin/bash

# br03-lost-commits/verify.sh
# Checks whether the learner recovered all 4 original commits.
# Run from broken-repos/br03-lost-commits/

WORKSPACE="br03-workspace"
PASS=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  br03-lost-commits — verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Check workspace exists ────────────────────────────────────────────────────
if [ ! -d "$WORKSPACE" ]; then
  echo "❌ br03-workspace/ not found. Run: bash setup.sh first."
  echo ""
  exit 1
fi

# ── Check 1: All 4 commits are reachable from HEAD ────────────────────────────
COMMIT_COUNT=$(git -C "$WORKSPACE" rev-list --count HEAD 2>/dev/null)

if [ "$COMMIT_COUNT" -lt 4 ]; then
  echo "❌ Only $COMMIT_COUNT commit(s) reachable from HEAD. Expected 4."
  echo "   The 3 lost commits haven't been recovered yet."
  PASS=false
else
  echo "✅ All 4 commits are reachable from HEAD ($COMMIT_COUNT total)."
fi

# ── Check 2: Specific commit messages exist in the log ───────────────────────
check_commit_message() {
  local msg="$1"
  if git -C "$WORKSPACE" log --oneline | grep -q "$msg"; then
    echo "✅ Found commit: \"$msg\""
  else
    echo "❌ Missing commit: \"$msg\""
    PASS=false
  fi
}

check_commit_message "Setup"
check_commit_message "Add high score tracking"
check_commit_message "Add level progression"
check_commit_message "Add combo multiplier"

# ── Check 3: game.js contains the combo function (latest state) ───────────────
if grep -q "updateCombo" "$WORKSPACE/game.js" 2>/dev/null; then
  echo "✅ game.js contains the combo multiplier code."
else
  echo "❌ game.js is missing the combo multiplier code."
  echo "   HEAD should be at the 'Add combo multiplier' commit."
  PASS=false
fi

# ── Check 4: Working tree is clean ────────────────────────────────────────────
STATUS=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null)
if [ -n "$STATUS" ]; then
  echo "❌ Working tree is not clean. Uncommitted changes present:"
  echo "$STATUS"
  PASS=false
else
  echo "✅ Working tree is clean."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$PASS" = true ]; then
  echo ""
  echo "  ✅ All checks passed."
  echo ""
  echo "  You recovered all 3 lost commits using git reflog."
  echo "  git reset --hard is scary, but it's not permanent — reflog is your safety net."
  echo ""
else
  echo ""
  echo "  ❌ Some checks failed. See above for details."
  echo ""
  echo "  To start over: bash setup.sh"
  echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
