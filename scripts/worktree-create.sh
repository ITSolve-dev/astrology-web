#!/usr/bin/env bash
set -euo pipefail

# Create a git worktree for a new task.
#
# Usage:
#   ./scripts/worktree-create.sh ISSUE=<n>
#   ./scripts/worktree-create.sh BRANCH=<branch-name>

ISSUE=""
BRANCH=""

for arg in "$@"; do
    case "$arg" in
        ISSUE=*) ISSUE="${arg#ISSUE=}" ;;
        BRANCH=*) BRANCH="${arg#BRANCH=}" ;;
    esac
done

if [[ -z "$ISSUE" && -z "$BRANCH" ]]; then
    echo "Usage: make worktree-create ISSUE=<n> or make worktree-create BRANCH=<name>"
    exit 1
fi

# Fetch latest main
git fetch origin main --quiet

# Derive branch name from issue
if [[ -n "$ISSUE" && -z "$BRANCH" ]]; then
    echo "Fetching issue #${ISSUE}..."
    issue_title=$(gh issue view "$ISSUE" --json title --jq '.title')
    slug=$(echo "$issue_title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//' | cut -c1-50)
    author=$(git config user.name | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
    author="${author:-unknown-author}"
    issue_type=$(gh issue view "$ISSUE" --json labels --jq '.labels[0].name // "feature"' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
    issue_type="${issue_type:-feature}"
    BRANCH="${author}/${issue_type}/${ISSUE}-${slug}"
fi

worktree_name=$(echo "$BRANCH" | sed 's|.*/||')
worktree_path=".worktrees/${worktree_name}"

echo "Creating worktree: ${worktree_path}"
echo "Branch: ${BRANCH}"

git worktree add "$worktree_path" -b "$BRANCH" origin/main

# Symlink .env if exists
if [[ -f ".env" ]]; then
    ln -sf "../../.env" "${worktree_path}/.env"
    echo "Symlinked .env"
fi

echo ""
echo "=== Worktree ready ==="
echo "  cd ${worktree_path}"
echo "  bun install"
