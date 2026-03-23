#!/usr/bin/env bash

# Script: git-switch-branches.sh
# Finds all Git repositories and interactively switches to main or master branch.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # reset color

find . -type d -name ".git" | while read -r gitdir; do
  repo_dir=$(dirname "$gitdir")
  echo -e "\n${YELLOW}→ Repository: $repo_dir${NC}"
  cd "$repo_dir" || continue

  # Check if main or master exist
  has_main=$(git show-ref --quiet refs/heads/main && echo "yes" || echo "no")
  has_master=$(git show-ref --quiet refs/heads/master && echo "yes" || echo "no")

  # Show available branches
  echo "Available branches:"
  [ "$has_main" = "yes" ] && echo " - main"
  [ "$has_master" = "yes" ] && echo " - master"

  # Ask user
  read -rp "Switch to 'main' or 'master'? (type name or skip): " choice

  if [ "$choice" = "main" ] && [ "$has_main" = "yes" ]; then
    git checkout main && echo -e "${GREEN}✔ Switched to main${NC}"
  elif [ "$choice" = "master" ] && [ "$has_master" = "yes" ]; then
    git checkout master && echo -e "${GREEN}✔ Switched to master${NC}"
  else
    echo "Skipped."
  fi

  cd - >/dev/null || exit
done
