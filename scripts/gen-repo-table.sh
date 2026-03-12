#!/bin/bash
# Recursively scans for git repositories and generates a markdown table.
# Usage: bash gen-repo-table.sh [ROOT_DIR] [MAX_DEPTH]
#        Defaults: ROOT_DIR=script's directory, MAX_DEPTH=5
# Output is sorted by remote URL (repos with no remote go last).

set -euo pipefail

ROOT_DIR="${1:-$(cd "$(dirname "$0")" && pwd)}"
MAX_DEPTH="${2:-5}"
OUTPUT_FILE="${ROOT_DIR}/REPO_TABLE.md"

tmp_repos=$(mktemp)
tmp_rows=$(mktemp)
trap 'rm -f "$tmp_repos" "$tmp_rows"' EXIT

find "$ROOT_DIR" -maxdepth "$MAX_DEPTH" -name ".git" -type d 2>/dev/null | sort > "$tmp_repos"
total=$(wc -l < "$tmp_repos" | tr -d ' ')

SEP=$'\x1f'

i=0
while IFS= read -r git_dir; do
  repo_dir="${git_dir%/.git}"
  i=$((i + 1))

  name=$(basename "$repo_dir")
  rel_path="${repo_dir#"$ROOT_DIR"/}"

  branch=$(git -C "$repo_dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
    branch="detached"
  fi

  remotes=$(git -C "$repo_dir" remote -v 2>/dev/null \
    | awk '/\(fetch\)/ {print $2}' \
    | sort -u \
    | tr '\n' ' ' \
    | sed 's/ $//')
  [ -z "$remotes" ] && remotes="—"

  last_commit=$(git -C "$repo_dir" log -1 --format='%ad · %s' --date=short 2>/dev/null || true)
  if [ -z "$last_commit" ]; then
    last_commit="—"
  fi
  last_commit="${last_commit//|/\\|}"

  dirty=$(git -C "$repo_dir" status --porcelain 2>/dev/null | head -1)
  if [ -n "$dirty" ]; then
    status="dirty"
  else
    status="clean"
  fi

  lang=$(find "$repo_dir" -maxdepth 3 \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    -not -path '*/venv/*' \
    -not -path '*/.venv/*' \
    -not -path '*/__pycache__/*' \
    -not -path '*/vendor/*' \
    -type f -name '*.*' 2>/dev/null \
    | sed 's/.*\.//' \
    | sort | uniq -c | sort -rn \
    | awk 'NR==1 {print $2}')
  [ -z "$lang" ] && lang="—"

  sort_key="$remotes"
  [ "$sort_key" = "—" ] && sort_key="~~~"

  echo "${sort_key}${SEP}${name}${SEP}${rel_path}${SEP}${remotes}${SEP}${branch}${SEP}${last_commit}${SEP}${status}${SEP}${lang}" >> "$tmp_rows"

  >&2 printf "\r  [%d/%d] %s                    " "$i" "$total" "$name"
done < "$tmp_repos"

{
  echo "# Repository Inventory"
  echo ""
  echo "_Generated: $(date '+%Y-%m-%d %H:%M')_"
  echo "_Root: \`${ROOT_DIR}\`_"
  echo "_Total repositories: ${total}_"
  echo "_Sorted by: remote URL_"
  echo ""
  echo "| # | Name | Local Path | Remote(s) | Branch | Last Commit | Status | Lang |"
  echo "|---|------|-----------|-----------|--------|-------------|--------|------|"

  sort -t"$SEP" -k1,1 "$tmp_rows" | awk -F"$SEP" '{
    printf "| %d | **%s** | `%s` | %s | `%s` | %s | %s | %s |\n", NR, $2, $3, $4, $5, $6, $7, $8
  }'

  echo ""
} > "$OUTPUT_FILE"

>&2 echo ""
>&2 echo "Done! ${total} repos → ${OUTPUT_FILE}"
