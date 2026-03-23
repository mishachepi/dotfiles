#!/bin/bash
# Loading env from .env file (improved version)

set -a  # Automatically export all variables

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

# Load .env file, filtering out comments and empty lines
while IFS='=' read -r key value; do
    # Skip empty lines
    [ -z "$key" ] && continue

    # Skip comments (lines starting with #)
    [[ "$key" =~ ^[[:space:]]*# ]] && continue

    # Remove leading/trailing whitespace from key
    key=$(echo "$key" | xargs)

    # Skip if key is empty after trimming
    [ -z "$key" ] && continue

    # Export the variable
    export "$key=$value"
done < .env

set +a

echo "Environment variables loaded from .env"
