#!/usr/bin/env bash
set -euo pipefail

# Remove a git worktree and its branch.
#
# Usage:
#   ./scripts/worktree-cleanup.sh           # auto-detect from cwd
#   ./scripts/worktree-cleanup.sh NAME=<n>  # explicit name

NAME=""

for arg in "$@"; do
    case "$arg" in
        NAME=*) NAME="${arg#NAME=}" ;;
    esac
done

# Auto-detect from cwd if inside a worktree
if [[ -z "$NAME" ]]; then
    cwd=$(pwd)
    if [[ "$cwd" == *".worktrees/"* ]]; then
        NAME=$(echo "$cwd" | sed 's|.*\.worktrees/||' | cut -d'/' -f1)
    else
        echo "Error: not inside a worktree. Use NAME=<name> to specify."
        exit 1
    fi
fi

repo_root=$(git rev-parse --show-toplevel)
worktree_path="${repo_root}/.worktrees/${NAME}"
branch=$(git -C "$worktree_path" branch --show-current 2>/dev/null || true)

echo "Removing worktree: ${worktree_path}"
git worktree remove "$worktree_path" --force

if [[ -n "$branch" ]]; then
    echo "Deleting branch: ${branch}"
    git branch -D "$branch" 2>/dev/null || true
fi

echo "Done."
