#!/bin/bash

NOW=$(date '+%Y-%m-%d_%H-%M-%S')

RAW_LOG="./session-$NOW.log"

echo "🔴Session recording started."
echo "Type 'exit' to finish."
script -q -F "$RAW_LOG"
echo "🔴Session recording finished."

echo "Encrypting session recording."
gpg -c "$RAW_LOG"
echo "Recording encrypted and saved to $RAW_LOG.gpg"

rm -f "$RAW_LOG"
echo "Original recording was deleted"
