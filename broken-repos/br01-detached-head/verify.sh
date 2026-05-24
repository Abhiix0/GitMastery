#!/bin/bash

# br01-detached-head/verify.sh
# Checks whether the learner rescued their detached HEAD commit onto a branch.
# Run from broken-repos/br01-detached-head/

WORKSPACE="br01-workspace"
PASS=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  br01-detached-head — verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Check workspace exists ────────────────────────────────────────────────────
if [ ! -d "$WORKSPACE" ]; then
  echo "❌ br01-workspace/ not found. Run: bash setup.sh first."
  echo ""
  exit 1
fi

# ── Check 1: Not in detached HEAD ─────────────────────────────────────────────
HEAD_REF=$(git -C "$WORKSPACE" symbolic-ref HEAD 2>/dev/null || echo "DETACHED")

if [ "$HEAD_REF" = "DETACHED" ]; then
  echo "❌ Still in detached HEAD state."
  echo "   You need to create a branch that points to your hotfix commit."
  echo "   Try: git checkout -b hotfix  (or any branch name)"
  PASS=false
else
  BRANCH_NAME=$(basename "$HEAD_REF")
  echo "✅ HEAD is attached to branch: $BRANCH_NAME"
fi

# ── Check 2: hotfix.html exists in the working tree ──────────────────────────
if [ ! -f "$WORKSPACE/hotfix.html" ]; then
  echo "❌ hotfix.html not found in the workspace."
  echo "   Create the file and commit it while in detached HEAD, then save it"
  echo "   by attaching HEAD to a branch before switching away."
  PASS=false
else
  echo "✅ hotfix.html exists in the working tree."
fi

# ── Check 3: hotfix.html is tracked in git (committed, not just created) ──────
TRACKED=$(git -C "$WORKSPACE" ls-files hotfix.html 2>/dev/null)
if [ -z "$TRACKED" ]; then
  echo "❌ hotfix.html exists on disk but isn't committed."
  echo "   git add hotfix.html && git commit -m 'Add hotfix'"
  PASS=false
else
  echo "✅ hotfix.html is committed."
fi

# ── Check 4: A branch exists that contains the hotfix.html commit ─────────────
# Find the commit that introduced hotfix.html
HOTFIX_COMMIT=$(git -C "$WORKSPACE" log --all --diff-filter=A --pretty=format:"%H" -- hotfix.html 2>/dev/null | head -1)

if [ -z "$HOTFIX_COMMIT" ]; then
  echo "❌ Could not find a commit that added hotfix.html."
  PASS=false
else
  # Check that at least one branch (not just a detached ref) contains this commit
  BRANCHES_WITH_COMMIT=$(git -C "$WORKSPACE" branch --contains "$HOTFIX_COMMIT" 2>/dev/null)
  if [ -z "$BRANCHES_WITH_COMMIT" ]; then
    echo "❌ The hotfix commit exists but no branch points to it."
    echo "   It will be garbage collected eventually."
    echo "   Run: git branch hotfix-rescue $HOTFIX_COMMIT"
    PASS=false
  else
    echo "✅ A branch contains the hotfix commit: $BRANCHES_WITH_COMMIT"
  fi
fi

# ── Check 5: All 3 original commits still exist ───────────────────────────────
COMMIT_COUNT=$(git -C "$WORKSPACE" log --all --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$COMMIT_COUNT" -lt 4 ]; then
  echo "❌ Expected at least 4 commits (3 original + hotfix). Found: $COMMIT_COUNT"
  PASS=false
else
  echo "✅ All original commits are intact ($COMMIT_COUNT total commits)."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$PASS" = true ]; then
  echo ""
  echo "  ✅ All checks passed."
  echo ""
  echo "  You rescued a commit from detached HEAD and attached it to a branch."
  echo "  That's the move. Nothing was lost."
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
