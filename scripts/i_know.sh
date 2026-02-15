#!/usr/bin/env bash
set -euo pipefail

KNOWN_HOSTS="${KNOWN_HOSTS:-${HOME}/.ssh/known_hosts}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

DRY_RUN=false

die() { echo -e "error: $*" >&2; exit 1; }

usage() {
    cat <<'EOF'
i_know — remove entries from ~/.ssh/known_hosts

Usage:
  i_know <host_or_ip>             search & remove by pattern
  i_know '[host]:port'            remove exact host:port
  ssh user@host 2>&1 | i_know     parse SSH error from pipe

Options:
  -n, --dry-run    show what would be removed
  -h, --help       show this help

Examples:
  i_know 192.168.1.1
  i_know github.com
  i_know -n 10.0.0.5
  ssh git@github.com 2>&1 | i_know
EOF
    exit 0
}

# --- helpers ---

# Ask user a question (reads from terminal even when stdin is a pipe)
ask() {
    local prompt="$1"
    { read -rp "$prompt" REPLY < /dev/tty; } 2>/dev/null || read -rp "$prompt" REPLY
}

# Delete line from file (handles macOS/Linux sed difference)
delete_line() {
    local file="$1" line_num="$2"
    if sed --version >/dev/null 2>&1; then
        sed -i "${line_num}d" "$file"
    else
        sed -i '' "${line_num}d" "$file"
    fi
}

# Parse SSH error output for hostname
parse_ssh_error() {
    local text="$1" hp

    # [host]:port
    hp=$(printf '%s\n' "$text" | sed -nE 's/.*Host key for (\[[^]]+\]:[0-9]+).*/\1/p' | head -1)
    [ -n "$hp" ] && { echo "$hp"; return; }

    # "Host key for <host> has changed"
    hp=$(printf '%s\n' "$text" | sed -nE 's/.*Host key for ([^ ]+) has changed.*/\1/p' | head -1)
    [ -n "$hp" ] && { echo "$hp"; return; }

    return 1
}

# Parse SSH error output for line number
parse_ssh_line() {
    printf '%s\n' "$1" | sed -nE 's/.*known_hosts:([0-9]+).*/\1/p' | head -1
}

# Find matching entries, populate MATCH_NUMS and MATCH_HOSTS arrays
find_entries() {
    local pattern="$1"
    MATCH_NUMS=()
    MATCH_HOSTS=()

    [ -f "$KNOWN_HOSTS" ] || die "not found: $KNOWN_HOSTS"

    local matches
    matches=$(grep -n "$pattern" "$KNOWN_HOSTS" 2>/dev/null || true)
    [ -z "$matches" ] && return 1

    while IFS=: read -r num content; do
        MATCH_NUMS+=("$num")
        MATCH_HOSTS+=("${content%% *}")
    done <<< "$matches"
    return 0
}

# Display found entries
show_entries() {
    echo ""
    for i in "${!MATCH_NUMS[@]}"; do
        printf "  ${YELLOW}%d${NC}) line %-4s  %s\n" "$((i+1))" "${MATCH_NUMS[$i]}" "${MATCH_HOSTS[$i]}"
    done
    echo ""
}

# Backup + remove lines (pass line numbers in reverse order)
do_remove() {
    local count=$#
    cp "$KNOWN_HOSTS" "${KNOWN_HOSTS}.bak"
    for n in "$@"; do
        delete_line "$KNOWN_HOSTS" "$n"
    done
    echo -e "${GREEN}done:${NC} removed ${count} entries (backup: known_hosts.bak)"
}

# --- main logic ---

remove_entries() {
    local pattern="$1"

    echo -e "Searching ${YELLOW}${pattern}${NC} in known_hosts..."

    if ! find_entries "$pattern"; then
        die "no entries found for: $pattern"
    fi

    local total=${#MATCH_NUMS[@]}
    show_entries

    if [ "$DRY_RUN" = true ]; then
        echo -e "${DIM}dry run — ${total} entries would be removed${NC}"
        return 0
    fi

    # Ask what to do
    local to_remove=()

    if [ "$total" -eq 1 ]; then
        ask "Remove? [y/n]: "
        [[ "$REPLY" =~ ^[Yy]$ ]] || { echo "Cancelled."; return 1; }
        to_remove=("${MATCH_NUMS[0]}")
    else
        ask "Remove: (a)ll / (c)hoose / (n)o? "
        case "$REPLY" in
            a|A)
                to_remove=("${MATCH_NUMS[@]}")
                ;;
            c|C)
                for i in "${!MATCH_NUMS[@]}"; do
                    ask "  ${MATCH_HOSTS[$i]} (line ${MATCH_NUMS[$i]})? [y/n]: "
                    [[ "$REPLY" =~ ^[Yy]$ ]] && to_remove+=("${MATCH_NUMS[$i]}")
                done
                [ ${#to_remove[@]} -eq 0 ] && { echo "Nothing selected."; return 1; }
                ;;
            *)
                echo "Cancelled."; return 1
                ;;
        esac
    fi

    # Remove in reverse order so line numbers don't shift
    local sorted
    sorted=$(printf '%s\n' "${to_remove[@]}" | sort -rn)
    do_remove $sorted
}

# --- arg parsing ---

TARGET=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=true ;;
        -h|--help)    usage ;;
        -*)           die "unknown option: $1 (see --help)" ;;
        *)            TARGET="$1" ;;
    esac
    shift
done

# Pipe mode: parse SSH error from stdin (only when no argument given)
if [ ! -t 0 ] && [ -z "$TARGET" ]; then
    INPUT="$(cat)"
    TARGET=$(parse_ssh_error "$INPUT" || true)

    # Fallback: remove by line number from SSH error
    if [ -z "$TARGET" ]; then
        LINE=$(parse_ssh_line "$INPUT" || true)
        if [ -n "$LINE" ]; then
            echo -e "Removing line ${YELLOW}${LINE}${NC} from known_hosts..."
            if [ "$DRY_RUN" = true ]; then
                echo -e "${DIM}dry run — line ${LINE} would be removed${NC}"
                exit 0
            fi
            cp "$KNOWN_HOSTS" "${KNOWN_HOSTS}.bak"
            delete_line "$KNOWN_HOSTS" "$LINE"
            echo -e "${GREEN}done:${NC} removed line ${LINE} (backup: known_hosts.bak)"
            exit 0
        fi
    fi
fi

if [ -z "$TARGET" ]; then
    echo "Usage: i_know <host_or_ip>"
    echo "       ssh user@host 2>&1 | i_know"
    echo "       i_know --help"
    exit 2
fi

remove_entries "$TARGET"
