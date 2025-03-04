#!/bin/bash

clean_caches() {
    echo "Calculating caches size..."
    size1=$(du -sh ~/Library/Caches 2>/dev/null | awk '{print $1}')
    size2=$(sudo du -sh /Library/Caches 2>/dev/null | awk '{print $1}')
    size3=$(sudo du -sh /System/Library/Caches 2>/dev/null | awk '{print $1}')
    echo "Caches to delete:"
    echo "User Caches (~/Library/Caches): $size1"
    echo "System Caches (/Library/Caches): $size2"
    echo "System Caches (/System/Library/Caches): $size3"
    read -p "Delete caches? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Deleting caches..."
        sudo rm -rf ~/Library/Caches/*
        sudo rm -rf /Library/Caches/*
        sudo rm -rf /System/Library/Caches/*
    else
        echo "Caches not deleted."
    fi
}

clean_logs() {
    echo "Calculating logs size..."
    size1=$(sudo du -sh /private/var/log 2>/dev/null | awk '{print $1}')
    size2=$(du -sh ~/Library/Logs 2>/dev/null | awk '{print $1}')
    echo "Logs to delete:"
    echo "System Logs (/private/var/log): $size1"
    echo "User Logs (~/Library/Logs): $size2"
    read -p "Delete logs? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Deleting logs..."
        sudo rm -rf /private/var/log/*
        rm -rf ~/Library/Logs/*
    else
        echo "Logs not deleted."
    fi
}

clean_temp() {
    echo "Calculating temporary files size..."
    size1=$(sudo du -sh /private/var/folders 2>/dev/null | awk '{print $1}')
    size2=$(du -sh /tmp 2>/dev/null | awk '{print $1}')
    echo "Temporary files to delete:"
    echo "/private/var/folders: $size1"
    echo "/tmp: $size2"
    read -p "Delete temporary files? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Deleting temporary files..."
        sudo rm -rf /private/var/folders/*
        sudo rm -rf /tmp/*
    else
        echo "Temporary files not deleted."
    fi
}

clean_homebrew() {
    echo "Dry run for Homebrew cleanup:"
    brew cleanup -n
    read -p "Perform Homebrew cleanup? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Cleaning Homebrew..."
        brew cleanup -s
        brew autoremove
    else
        echo "Homebrew cleanup skipped."
    fi
}

clean_docker() {
    echo "Docker disk usage:"
    docker system df
    read -p "Clean Docker (remove unused images, containers, volumes)? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        echo "Cleaning Docker..."
        docker system prune -a --volumes -f
    else
        echo "Docker cleanup skipped."
    fi
}

main() {
    echo "Starting macOS cleanup..."
    clean_caches
    clean_logs
    clean_temp
    clean_homebrew
    clean_docker
    echo "Cleanup complete."
}

main
