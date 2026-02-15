#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track freed space
declare -A freed_space

human_size() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt $((1024 * 1024)) ]; then
        echo "$(bc <<< "scale=2; $bytes / 1024")KB"
    elif [ "$bytes" -lt $((1024 * 1024 * 1024)) ]; then
        echo "$(bc <<< "scale=2; $bytes / 1024 / 1024")MB"
    else
        echo "$(bc <<< "scale=2; $bytes / 1024 / 1024 / 1024")GB"
    fi
}

clean_caches() {
    echo -e "${BLUE}=== System Caches ===${NC}"
    size1=$(du -sk ~/Library/Caches 2>/dev/null | awk '{print $1}')
    size2=$(sudo du -sk /Library/Caches 2>/dev/null | awk '{print $1}')
    size3=$(sudo du -sk /System/Library/Caches 2>/dev/null | awk '{print $1}')
    total_kb=$((size1 + size2 + size3))

    echo "User Caches: $(human_size $((size1 * 1024)))"
    echo "System Caches: $(human_size $((size2 * 1024)))"
    echo "Total: $(human_size $((total_kb * 1024)))"

    read -p "Delete system caches? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        sudo rm -rf ~/Library/Caches/*
        sudo rm -rf /Library/Caches/*
        sudo rm -rf /System/Library/Caches/*
        freed_space["System caches"]=$((total_kb * 1024))
        echo -e "${GREEN}✓ Deleted${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_logs() {
    echo -e "${BLUE}=== Logs ===${NC}"
    size1=$(sudo du -sk /private/var/log 2>/dev/null | awk '{print $1}')
    size2=$(du -sk ~/Library/Logs 2>/dev/null | awk '{print $1}')
    total_kb=$((size1 + size2))

    echo "System Logs: $(human_size $((size1 * 1024)))"
    echo "User Logs: $(human_size $((size2 * 1024)))"
    echo "Total: $(human_size $((total_kb * 1024)))"

    read -p "Delete logs? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        sudo rm -rf /private/var/log/*
        rm -rf ~/Library/Logs/*
        freed_space["Logs"]=$((total_kb * 1024))
        echo -e "${GREEN}✓ Deleted${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_temp() {
    echo -e "${BLUE}=== Temporary Files ===${NC}"
    size1=$(sudo du -sk /private/var/folders 2>/dev/null | awk '{print $1}')
    size2=$(du -sk /tmp 2>/dev/null | awk '{print $1}')
    total_kb=$((size1 + size2))

    echo "/private/var/folders: $(human_size $((size1 * 1024)))"
    echo "/tmp: $(human_size $((size2 * 1024)))"
    echo "Total: $(human_size $((total_kb * 1024)))"

    read -p "Delete temporary files? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        sudo rm -rf /private/var/folders/*
        sudo rm -rf /tmp/*
        freed_space["Temp files"]=$((total_kb * 1024))
        echo -e "${GREEN}✓ Deleted${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_homebrew() {
    echo -e "${BLUE}=== Homebrew ===${NC}"
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not installed, skipping"
        return
    fi

    # Get cache size before cleanup
    cache_dir="$(brew --cache)"
    if [ -d "$cache_dir" ]; then
        size_before=$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')
    else
        size_before=0
    fi

    echo "Cache location: $cache_dir"
    echo "Current cache size: $(human_size $((size_before * 1024)))"
    echo ""
    brew cleanup -n

    read -p "Perform Homebrew cleanup? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        brew cleanup -s
        brew autoremove

        # Calculate freed space
        if [ -d "$cache_dir" ]; then
            size_after=$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')
        else
            size_after=0
        fi
        freed_kb=$((size_before - size_after))
        freed_space["Homebrew cache"]=$((freed_kb * 1024))
        echo -e "${GREEN}✓ Cleaned${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_docker() {
    echo -e "${BLUE}=== Docker ===${NC}"
    if ! command -v docker &> /dev/null; then
        echo "Docker not installed, skipping"
        return
    fi

    if ! docker info &> /dev/null; then
        echo "Docker daemon not running, skipping"
        return
    fi

    # Get size before cleanup
    size_line=$(docker system df | grep -E "^Total" | awk '{print $(NF-1), $NF}')

    echo "Current Docker disk usage:"
    docker system df
    echo ""

    read -p "Clean Docker (remove unused images, containers, volumes)? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        # Parse size before (e.g., "22.94GB" or "1.5GB")
        size_value=$(echo "$size_line" | awk '{print $1}')
        size_unit=$(echo "$size_line" | awk '{print $2}')

        docker system prune -a --volumes -f

        # Convert to bytes for tracking
        if [[ "$size_unit" == "GB" ]]; then
            freed_bytes=$(bc <<< "$size_value * 1024 * 1024 * 1024" | cut -d. -f1)
        elif [[ "$size_unit" == "MB" ]]; then
            freed_bytes=$(bc <<< "$size_value * 1024 * 1024" | cut -d. -f1)
        else
            freed_bytes=0
        fi

        freed_space["Docker (images, containers, volumes, build cache)"]=$freed_bytes
        echo -e "${GREEN}✓ Cleaned${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_npm() {
    echo -e "${BLUE}=== npm Cache ===${NC}"
    if ! command -v npm &> /dev/null; then
        echo "npm not installed, skipping"
        return
    fi

    cache_dir=$(npm config get cache)
    if [ -d "$cache_dir" ]; then
        size_kb=$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')
        echo "Cache location: $cache_dir"
        echo "Cache size: $(human_size $((size_kb * 1024)))"
    else
        echo "No npm cache found"
        return
    fi

    read -p "Clean npm cache? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        npm cache clean --force
        freed_space["npm cache"]=$((size_kb * 1024))
        echo -e "${GREEN}✓ Cleaned${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

clean_uv() {
    echo -e "${BLUE}=== uv Cache (Python) ===${NC}"
    if ! command -v uv &> /dev/null; then
        echo "uv not installed, skipping"
        return
    fi

    cache_dir="$HOME/Library/Caches/uv"
    if [ -d "$cache_dir" ]; then
        size_kb=$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')
        echo "Cache location: $cache_dir"
        echo "Cache size: $(human_size $((size_kb * 1024)))"
    else
        echo "No uv cache found"
        return
    fi

    read -p "Clean uv cache? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        uv cache clean
        freed_space["uv cache (Python)"]=$((size_kb * 1024))
        echo -e "${GREEN}✓ Cleaned${NC}\n"
    else
        echo -e "${YELLOW}Skipped${NC}\n"
    fi
}

print_summary() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    CLEANUP SUMMARY                        ║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════╣${NC}"

    if [ ${#freed_space[@]} -eq 0 ]; then
        echo -e "${GREEN}║${NC}  ${YELLOW}No space was freed (nothing was cleaned)${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
        return
    fi

    # Calculate total
    total_freed=0

    # Print each item
    for item in "${!freed_space[@]}"; do
        bytes=${freed_space[$item]}
        total_freed=$((total_freed + bytes))
        size_str=$(human_size $bytes)

        # Format output
        printf "${GREEN}║${NC} %-50s ${BLUE}%10s${NC} ${GREEN}║${NC}\n" "$item" "$size_str"
    done

    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════╣${NC}"
    printf "${GREEN}║${NC} ${YELLOW}%-50s %10s${NC} ${GREEN}║${NC}\n" "TOTAL FREED" "$(human_size $total_freed)"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
}

main() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║        macOS System Cleanup Utility              ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════╝${NC}"
    echo ""

    clean_docker
    clean_homebrew
    clean_npm
    clean_uv
    clean_caches
    clean_logs
    clean_temp

    print_summary
    echo ""
    echo -e "${GREEN}Cleanup complete!${NC}"
}

main
