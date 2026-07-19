#!/usr/bin/env bash
input=$(cat)

# --- Extract values ---
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "."')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
API_MS=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')
TOK_IN=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
TOK_OUT=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
CACHE_PCT=$(echo "$input" | jq -r '
  .context_window.current_usage
  | (.cache_read_input_tokens // 0) as $r
  | ((.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.input_tokens // 0)) as $t
  | if $t > 0 then ($r * 100 / $t | floor) else 0 end')

# output tokens per second (based on API time, not wall clock)
[ "$API_MS" -gt 0 ] && SPEED=$(( TOK_OUT * 1000 / API_MS )) || SPEED=0

# --- Colors ---
R='\033[0m'
DIM='\033[38;2;130;140;150m'    # labels / separators
BRIGHT='\033[38;2;205;210;215m' # primary metrics (%, speed, tokens)
ACCENT='\033[38;2;245;180;80m'  # model / time / cost
TRACK='\033[38;2;80;86;94m'     # empty bar segment (drawn with ░)
GREEN='\033[38;2;150;210;80m'
YELLOW='\033[38;2;235;210;70m'
RED='\033[38;2;235;70;70m'

# --- Helpers ---
number() {
  local n=$1
  if   [ "$n" -ge 1000000 ]; then printf "%.1fM" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000 ];    then printf "%.1fk" "$(echo "scale=1; $n/1000" | bc)"
  else printf "%d" "$n"; fi
}

fmt_dur() {
  local ms=$1; local s=$(( ms/1000 )); local m=$(( s/60 )); local h=$(( m/60 ))
  m=$(( m%60 )); s=$(( s%60 ))
  if [ "$h" -gt 0 ]; then printf "%d:%02d:%02d" "$h" "$m" "$s"
  else printf "%d:%02d" "$m" "$s"; fi
}

# bar: $1 = pct, $2 = "ctx" (green->red) or "cache" (red->green)
bar() {
  local pct=${1:-0}; local mode=$2; local w=10
  local f=$(( (pct * w + 50) / 100 ))
  [ $f -gt $w ] && f=$w; [ $f -lt 0 ] && f=0
  local e=$(( w - f ))
  local c="$GREEN"
  if [ "$mode" = "cache" ]; then
    c="$RED"; [ "$pct" -ge 50 ] && c="$YELLOW"; [ "$pct" -ge 80 ] && c="$GREEN"
  else
    [ "$pct" -ge 50 ] && c="$YELLOW"; [ "$pct" -ge 80 ] && c="$RED"
  fi
  local s=""; local i
  for ((i=0; i<f; i++)); do s+="█"; done
  printf "${c}%s${TRACK}" "$s"
  s=""; for ((i=0; i<e; i++)); do s+="░"; done
  printf "%s${R}" "$s"
}

# --- Branch ---
BRANCH=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
  b=$(git -C "$DIR" branch --show-current 2>/dev/null)
  [ -n "$b" ] && BRANCH=" ${DIM}on${R} ${GREEN}${b}${R}"
fi

# --- Line 1: context ---
printf "%b\n" "${ACCENT}${MODEL}${R} ${BRIGHT}${DIR##*/}${R}${BRANCH}"

# --- Line 2: metrics ---
SEP="${DIM} · ${R}"
out=""
out+="$(bar "$PCT" ctx) ${BRIGHT}${PCT}%${R}"
out+="${SEP}${DIM}cache${R} $(bar "$CACHE_PCT" cache) ${BRIGHT}${CACHE_PCT}%${R}"
out+="${SEP}${ACCENT}\$$(printf '%.2f' "$COST")${R}"
out+="${SEP}${ACCENT}$(fmt_dur "$DURATION_MS")${R}"
out+="${SEP}${BRIGHT}${SPEED}t/s${R}"
out+="${SEP}${BRIGHT}↓$(number "$TOK_IN") ↑$(number "$TOK_OUT")${R}"
printf "%b" "$out"
