#!/usr/bin/env bash
set -euo pipefail

# Squash all commits on the current branch (since it diverged from main) into one.
#
# Usage:
#   ./scripts/squash.sh "type(scope): description (#N)"

MESSAGE="${1:-}"

if [[ -z "$MESSAGE" ]]; then
    echo "Usage: make squash MESSAGE=\"type(scope): description (#N)\""
    exit 1
fi

CURRENT_BRANCH=$(git branch --show-current)

if [[ "$CURRENT_BRANCH" == "main" ]]; then
    echo "Refusing to squash on main."
    exit 1
fi

git fetch origin main --quiet

MERGE_BASE=$(git merge-base origin/main HEAD)
COMMIT_COUNT=$(git rev-list --count "${MERGE_BASE}..HEAD")

if [[ "$COMMIT_COUNT" -le 1 ]]; then
    echo "Already a single commit (or none) ahead of main — nothing to squash."
    exit 0
fi

echo "Squashing ${COMMIT_COUNT} commits on '${CURRENT_BRANCH}' into one..."
git reset --soft "$MERGE_BASE"
git commit -m "$MESSAGE"

echo ""
echo "Done. Review with: git log --oneline origin/main..HEAD"
echo "Push with: git push --force-with-lease"
