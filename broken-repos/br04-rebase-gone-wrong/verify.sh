#!/bin/bash

# br04-rebase-gone-wrong/verify.sh
# Checks whether the learner resolved the broken rebase state.
# Run from broken-repos/br04-rebase-gone-wrong/

WORKSPACE="br04-workspace"
PASS=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  br04-rebase-gone-wrong — verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Check workspace exists ────────────────────────────────────────────────────
if [ ! -d "$WORKSPACE" ]; then
  echo "❌ br04-workspace/ not found. Run: bash setup.sh first."
  echo ""
  exit 1
fi

# ── Check 1: No rebase in progress ────────────────────────────────────────────
if [ -d "$WORKSPACE/.git/rebase-merge" ] || [ -d "$WORKSPACE/.git/rebase-apply" ]; then
  echo "❌ A rebase is still in progress."
  echo "   Either finish it (git rebase --continue) or abort it (git rebase --abort)."
  PASS=false
else
  echo "✅ No rebase in progress."
fi

# ── Check 2: No conflict markers in app.js ────────────────────────────────────
if [ -f "$WORKSPACE/app.js" ]; then
  if grep -qE '^(<<<<<<<|=======|>>>>>>>)' "$WORKSPACE/app.js"; then
    echo "❌ Conflict markers still present in app.js."
    echo "   Resolve the conflict: remove all <<<<<<<, =======, >>>>>>> lines."
    PASS=false
  else
    echo "✅ No conflict markers in app.js."
  fi
else
  echo "❌ app.js not found."
  PASS=false
fi

# ── Check 3: Working tree is clean ────────────────────────────────────────────
STATUS=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null)
if [ -n "$STATUS" ]; then
  echo "❌ Working tree is not clean:"
  echo "$STATUS"
  PASS=false
else
  echo "✅ Working tree is clean."
fi

# ── Check 4: HEAD is attached to a branch ─────────────────────────────────────
HEAD_REF=$(git -C "$WORKSPACE" symbolic-ref HEAD 2>/dev/null || echo "DETACHED")
if [ "$HEAD_REF" = "DETACHED" ]; then
  echo "❌ HEAD is detached. Make sure you're on a branch."
  PASS=false
else
  BRANCH=$(basename "$HEAD_REF")
  echo "✅ HEAD is on branch: $BRANCH"
fi

# ── Check 5: app.js is a valid JS file (no stray markers) ────────────────────
# Simple check: the file should contain the startGame function
if grep -q "function startGame" "$WORKSPACE/app.js" 2>/dev/null; then
  echo "✅ app.js contains startGame function — looks like valid JS."
else
  echo "❌ app.js doesn't contain startGame. The file may be in a broken state."
  PASS=false
fi

# ── Bonus check: did they finish the rebase (feature commits present)? ─────────
# This is informational — not a hard failure, since abort is also a valid solution
HAS_PAUSE=$(git -C "$WORKSPACE" log --all --oneline 2>/dev/null | grep -c "pauseGame" || true)
HAS_RESUME=$(git -C "$WORKSPACE" log --all --oneline 2>/dev/null | grep -c "resumeGame" || true)

if [ "$HAS_PAUSE" -gt 0 ] && [ "$HAS_RESUME" -gt 0 ]; then
  echo "✅ Feature commits (pauseGame, resumeGame) are present in history."
  echo "   Looks like you finished the rebase — both features preserved."
else
  echo "ℹ️  Feature commits not found in history — looks like you aborted the rebase."
  echo "   That's a valid solution. The repo is clean."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$PASS" = true ]; then
  echo ""
  echo "  ✅ All checks passed. The repo is in a clean state."
  echo ""
  echo "  No rebase in progress, no conflict markers, clean working tree."
  echo "  Whether you finished or aborted — you got it back to a known good state."
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
