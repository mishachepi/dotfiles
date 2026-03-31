#!/bin/bash
set -e

NOW=$(date '+%Y-%m-%d_%H-%M-%S')

RAW_LOG="./session-$NOW.log"

# Check gpg is available before recording
if ! command -v gpg &>/dev/null; then
  echo "Error: gpg is not installed. Recording aborted."
  exit 1
fi

echo "Session recording started."
echo "Type 'exit' to finish."
script -q -F "$RAW_LOG"
echo "Session recording finished."

echo "Encrypting session recording."
if gpg -c "$RAW_LOG"; then
  echo "Recording encrypted and saved to $RAW_LOG.gpg"
  rm -f "$RAW_LOG"
  echo "Original recording was deleted"
else
  echo "Error: gpg encryption failed. Raw log kept at $RAW_LOG"
  exit 1
fi
