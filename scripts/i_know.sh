#!/usr/bin/env bash
set -euo pipefail

KNOWN_HOSTS="${HOME}/.ssh/known_hosts"

INPUT=""
if [ ! -t 0 ]; then
  INPUT="$(cat)"
fi

extract_hostport() {
  local text="$1"

  local hp
  hp="$(printf "%s\n" "$text" \
        | sed -nE 's/.*Host key for (\[[^]]+\]:[0-9]+).*/\1/p' \
        | head -n1)"
  [ -n "$hp" ] && { echo "$hp"; return 0; }

  hp="$(printf "%s\n" "$text" \
        | sed -nE 's/.*Host key for ([^ ]+) has changed.*/\1/p' \
        | head -n1)"
  [ -n "$hp" ] && { echo "$hp"; return 0; }

  return 1
}

extract_line() {
  local text="$1"
  printf "%s\n" "$text" \
    | sed -nE 's/.*known_hosts:([0-9]+).*/\1/p' \
    | head -n1
}

HOSTPORT=""
LINE=""

if [ -n "$INPUT" ]; then
  HOSTPORT="$(extract_hostport "$INPUT" || true)"
  LINE="$(extract_line "$INPUT" || true)"
fi

if [ -z "$HOSTPORT" ] && [ "${#@}" -gt 0 ]; then
  HOSTPORT="$1"
fi

if [ -n "$HOSTPORT" ]; then
  echo "Removing from known_hosts by host: ${HOSTPORT}"
  ssh-keygen -R "${HOSTPORT}" -f "${KNOWN_HOSTS}" >/dev/null
  echo "Done."
  exit 0
fi

if [ -n "$LINE" ]; then
  echo "Removing from known_hosts by line: ${LINE}"
  # macOS sed needs backup suffix; Linux doesn't.
  if sed --version >/dev/null 2>&1; then
    sed -i "${LINE}d" "${KNOWN_HOSTS}"
  else
    sed -i '' "${LINE}d" "${KNOWN_HOSTS}"
  fi
  echo "Done."
  exit 0
fi

echo "i_know: can't detect host or line."
echo "Try: i_know '[host]:port'  or pipe raw ssh output."
exit 2
