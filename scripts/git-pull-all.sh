#!/usr/bin/env bash

# Script: git-pull-all.sh
# Finds all Git repositories and runs "git pull" on main or master branch.

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # reset color

# Find all directories containing a .git folder
find . -type d -name ".git" | while read -r gitdir; do
  repo_dir=$(dirname "$gitdir")
  echo -e "${YELLOW}→ Updating repository in: $repo_dir${NC}"
  cd "$repo_dir" || continue

  # Detect branch name
  if git show-ref --quiet refs/heads/main; then
    branch="main"
  elif git show-ref --quiet refs/heads/master; then
    branch="master"
  else
    branch=$(git rev-parse --abbrev-ref HEAD)
  fi

  # Switch to the detected branch
  git checkout "$branch" >/dev/null 2>&1 || true

  # Pull updates
  if git pull origin "$branch"; then
    echo -e "${GREEN}✔ Updated: $repo_dir ($branch)${NC}"
  else
    echo -e "${RED}✖ Failed to update: $repo_dir${NC}"
  fi

  cd - >/dev/null || exit
done
